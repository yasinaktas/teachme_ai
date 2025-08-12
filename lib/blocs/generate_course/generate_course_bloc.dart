import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/dto/dto_chapter_content.dart';
import 'package:teachme_ai/dto/dto_chapter_questions.dart';
import 'package:teachme_ai/dto/dto_chapter_transcript.dart';
import 'package:teachme_ai/dto/dto_subtitles.dart';
import 'package:teachme_ai/helper/generate_random_id.dart';
import 'package:teachme_ai/models/answer.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/chapter_status.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/models/question.dart';
import 'package:teachme_ai/repositories/api_result.dart';
import 'package:teachme_ai/repositories/interfaces/i_generate_course_repository.dart';
import 'package:teachme_ai/repositories/interfaces/i_settings_repository.dart';
import 'package:teachme_ai/repositories/interfaces/i_tts_repository.dart';

class GenerateCourseBloc
    extends Bloc<GenerateCourseEvent, GenerateCourseState> {
  final IGenerateCourseRepository generateCourseRepository;
  final ITtsRepository ttsRepository;
  final ISettingsRepository settingsRepository;
  GenerateCourseBloc({
    required this.generateCourseRepository,
    required this.ttsRepository,
    required this.settingsRepository,
  }) : super(
         GenerateCourseState(
           course: Course(
             id: GenerateRandomId.generateRandomUUID(),
             title: "",
             description: "",
             language: "English",
             createdAt: DateTime.now(),
             chapters: [],
           ),
         ),
       ) {
    on<SelectLanguage>(_onSelectLanguage);
    on<SetTitle>(_onSetTitle);
    on<SetDescription>(_onSetDescription);
    on<SetChapterTitles>(_onSetChapterTitles);
    on<SetSubtitle>(_onSetSubtitle);
    on<ToggleLockTop>(_onToggleLockTop);
    on<ToggleLockBottom>(_onToggleLockBottom);
    on<AddSubtitle>(_onAddSubtitle);
    on<RemoveSubtitle>(_onRemoveSubtitle);
    on<ToggleGenerateQuestions>(_onToggleGenerateQuestions);
    on<GenerateChapterTitles>(_onGenerateChapterTitles);
    on<GenerateChapter>(_onGenerateChapter);
    on<GenerateCourse>(_onGenerateCourse);
    on<ReorderChapters>(_reOrderChapters);
    on<Clear>(_onClear);
    on<SelectDetailLevel>(_onSelectDetailLevel);

    _initializeLanguage();
  }

  void _initializeLanguage() async {
    final lang = await settingsRepository.getLanguage();
    add(SelectLanguage(lang));
  }

  void _onSelectLanguage(
    SelectLanguage event,
    Emitter<GenerateCourseState> emit,
  ) async {
    emit(
      state.copyWith(course: state.course.copyWith(language: event.language)),
    );
    await settingsRepository.setLanguage(event.language);
  }

  void _onToggleGenerateQuestions(
    ToggleGenerateQuestions event,
    Emitter<GenerateCourseState> emit,
  ) {
    emit(state.copyWith(generateQuestions: !state.generateQuestions));
  }

  void _onSetTitle(SetTitle event, Emitter<GenerateCourseState> emit) {
    emit(state.copyWith(course: state.course.copyWith(title: event.title)));
  }

  void _onSetDescription(
    SetDescription event,
    Emitter<GenerateCourseState> emit,
  ) {
    emit(
      state.copyWith(
        course: state.course.copyWith(description: event.description),
      ),
    );
  }

  void _onSetChapterTitles(
    SetChapterTitles event,
    Emitter<GenerateCourseState> emit,
  ) {
    final chapters = event.chapterTitles.map((title) {
      return Chapter(
        id: GenerateRandomId.generateRandomUUID(),
        courseId: state.course.id,
        title: title,
        description: "",
        content: "",
        transcript: "",
        questions: [],
      );
    }).toList();
    emit(
      state.copyWith(
        course: state.course.copyWith(chapters: chapters),
        errorMessage: null,
      ),
    );
  }

  void _onSetSubtitle(SetSubtitle event, Emitter<GenerateCourseState> emit) {
    if (event.subtitle.isEmpty) {
      emit(state.copyWith(errorMessage: "Subtitle cannot be empty"));
      return;
    }
    emit(state.copyWith(subtitle: event.subtitle, errorMessage: null));
  }

  void _onToggleLockTop(
    ToggleLockTop event,
    Emitter<GenerateCourseState> emit,
  ) {
    emit(state.copyWith(lockTop: event.lockTop));
  }

  void _onToggleLockBottom(
    ToggleLockBottom event,
    Emitter<GenerateCourseState> emit,
  ) {
    emit(state.copyWith(lockBottom: event.lockBottom));
  }

  void _onAddSubtitle(AddSubtitle event, Emitter<GenerateCourseState> emit) {
    if (state.subtitle == null || state.subtitle!.isEmpty) {
      emit(state.copyWith(errorMessage: "Subtitle cannot be empty"));
      return;
    }
    if (state.course.chapters.length >= 10) {
      emit(state.copyWith(errorMessage: "Maximum 10 chapters allowed"));
      return;
    }
    final updatedChapters = List<Chapter>.from(state.course.chapters);
    updatedChapters.add(
      Chapter(
        id: GenerateRandomId.generateRandomUUID(),
        courseId: state.course.id,
        title: state.subtitle!,
        description: "",
        content: "",
        transcript: "",
        questions: [],
      ),
    );
    emit(
      state.copyWith(
        course: state.course.copyWith(chapters: updatedChapters),
        subtitle: null,
        errorMessage: null,
      ),
    );
  }

  void _onRemoveSubtitle(
    RemoveSubtitle event,
    Emitter<GenerateCourseState> emit,
  ) {
    final updatedChapters = List<Chapter>.from(state.course.chapters);
    updatedChapters.removeWhere((chapter) => chapter.title == event.subtitle);
    emit(
      state.copyWith(
        course: state.course.copyWith(chapters: updatedChapters),
        errorMessage: null,
      ),
    );
  }

  Future<void> _onGenerateChapterTitles(
    GenerateChapterTitles event,
    Emitter<GenerateCourseState> emit,
  ) async {
    if (state.course.title.isEmpty) {
      emit(state.copyWith(errorMessage: "Title cannot be empty"));
      return;
    }
    emit(
      state.copyWith(
        isLoadingChapterTitles: true,
        errorMessage: null,
        lockTop: true,
      ),
    );
    try {
      final apiResult = await generateCourseRepository.getGeneratedSubtitles(
        state.course.title,
        state.course.language,
      );
      if (apiResult is Success) {
        final dtoSubtitles = apiResult as Success<DtoSubtitles>;
        emit(
          state.copyWith(
            course: state.course.copyWith(
              chapters: dtoSubtitles.data.subtitles.map((e) {
                return Chapter(
                  id: GenerateRandomId.generateRandomUUID(),
                  courseId: state.course.id,
                  title: e.title,
                  description: "",
                  content: "",
                  transcript: "",
                  questions: [],
                );
              }).toList(),
              description: dtoSubtitles.data.courseShortDescription,
            ),
            isLoadingChapterTitles: false,
            errorMessage: null,
            lockTop: true,
            lockBottom: false,
          ),
        );
      } else {
        final errorResult = apiResult as Failure<DtoSubtitles>;
        emit(
          state.copyWith(
            isLoadingChapterTitles: false,
            errorMessage: errorResult.message,
            lockTop: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingChapterTitles: false,
          lockTop: false,
          errorMessage: "Failed to generate chapter titles: ${e.toString()}",
        ),
      );
      return;
    }
  }

  Future<DtoChapterContent> _generateCourseContent(
    Chapter chapter,
    String title,
    String language,
    List<String> subtitles,
  ) async {
    final ApiResult<DtoChapterContent> apiResultGeneratedContent =
        await generateCourseRepository.getGeneratedChapterContent(
          title,
          language,
          chapter.title,
          subtitles,
        );
    if (apiResultGeneratedContent is Success) {
      return (apiResultGeneratedContent as Success).data;
    } else {
      final errorResult =
          apiResultGeneratedContent as Failure<DtoChapterContent>;
      throw Exception("Failed to generate content: ${errorResult.message}");
    }
  }

  Future<DtoChapterTranscript> _generateCourseTranscript(
    Chapter chapter,
    String title,
    String language,
    List<String> subtitles,
    String content,
  ) async {
    final ApiResult<DtoChapterTranscript> apiResultGeneratedTranscript =
        await generateCourseRepository.getGeneratedChapterTranscript(
          title,
          language,
          chapter.title,
          subtitles,
          content,
        );
    if (apiResultGeneratedTranscript is Success) {
      return (apiResultGeneratedTranscript as Success).data;
    } else {
      final errorResult =
          apiResultGeneratedTranscript as Failure<DtoChapterTranscript>;
      throw Exception("Failed to generate transcript: ${errorResult.message}");
    }
  }

  Future<List<Question>> _generateCourseQuestions(
    Chapter chapter,
    String title,
    String language,
    String content,
  ) async {
    final ApiResult<DtoChapterQuestions> apiResultGeneratedQuestions =
        await generateCourseRepository.generateChapterQuestions(
          title,
          language,
          chapter.title,
          content,
        );
    if (apiResultGeneratedQuestions is Success) {
      final List<DtoQuestion> dtoQuestions =
          (apiResultGeneratedQuestions as Success).data.questions;
      final List<Question> questions = dtoQuestions.map((dtoQuestion) {
        final String questionId = GenerateRandomId.generateRandomUUID();
        final List<DtoAnswer> dtoAnswers = dtoQuestion.answers;
        final List<Answer> answers = dtoAnswers.map((dtoAnswer) {
          final String id = GenerateRandomId.generateRandomUUID();
          return Answer(
            id: id,
            questionId: questionId,
            answerText: dtoAnswer.text,
            isCorrect: dtoAnswer.isCorrect,
          );
        }).toList();
        return Question(
          id: questionId,
          chapterId: chapter.id,
          questionText: dtoQuestion.questionText,
          answers: answers,
        );
      }).toList();
      return questions;
    } else {
      final errorResult =
          apiResultGeneratedQuestions as Failure<DtoChapterQuestions>;
      throw Exception("Failed to generate questions: ${errorResult.message}");
    }
  }

  /*Future<ApiResult<String>> _generateCourseAudio(
    Chapter chapter,
    String transcript,
  ) async {
    final language = AppLanguages.languages.firstWhere(
      (lang) => lang.name == state.course.language,
    );
    return await ttsRepository.generateSpeech(
      transcript,
      language.languageCode,
      language.voiceName,
      chapter.id,
    );
  }*/

  Future<void> _onGenerateChapter(
    GenerateChapter event,
    Emitter<GenerateCourseState> emit,
  ) async {
    final chapter = event.chapter;
    final title = state.course.title;
    final language = state.course.language;
    final subtitles = state.course.chapters.map((c) => c.title).toList();
    const int waitTime = 1000;
    emit(
      state.copyWith(
        chapterLoadingStatus: {
          ...state.chapterLoadingStatus,
          chapter.id: ChapterStatus(
            isGenerating: true,
            isContentGenerated: false,
            isTranscriptGenerated: false,
            isQuestionsGenerated: false,
            isAudioGenerated: false,
            generationResultCode: 0,
          ),
        },
      ),
    );

    try {
      final dtoContent = await _generateCourseContent(
        chapter,
        title,
        language,
        subtitles,
      );
      if (dtoContent is Failure<DtoChapterContent>) {
        emit(
          state.copyWith(
            errorMessage:
                "Failed to generate content for ${chapter.title}: ${(dtoContent as Failure).message}",
            chapterLoadingStatus: {
              ...state.chapterLoadingStatus,
              chapter.id: ChapterStatus(generationResultCode: -1),
            },
          ),
        );
        return;
      }
      await Future.delayed(Duration(milliseconds: waitTime));
      final dtoTranscript = await _generateCourseTranscript(
        chapter,
        title,
        language,
        subtitles,
        dtoContent.content,
      );
      if (dtoTranscript is Failure<DtoChapterTranscript>) {
        emit(
          state.copyWith(
            errorMessage:
                "Failed to generate transcript for ${chapter.title}: ${(dtoTranscript as Failure).message}",
            chapterLoadingStatus: {
              ...state.chapterLoadingStatus,
              chapter.id: ChapterStatus(generationResultCode: -2),
            },
          ),
        );
        return;
      }
      await Future.delayed(Duration(milliseconds: waitTime));
      List<Question> questions = [];
      if (state.generateQuestions) {
        final dtoQuestions = await _generateCourseQuestions(
          chapter,
          title,
          language,
          dtoContent.content,
        );
        if (dtoQuestions is Failure<DtoChapterQuestions>) {
          emit(
            state.copyWith(
              errorMessage:
                  "Failed to generate questions for ${chapter.title}: ${(dtoQuestions as Failure).message}",
              chapterLoadingStatus: {
                ...state.chapterLoadingStatus,
                chapter.id: ChapterStatus(generationResultCode: -3),
              },
            ),
          );
        } else {
          questions = dtoQuestions;
        }
      }
      //await Future.delayed(Duration(milliseconds: waitTime));
      //await _generateCourseAudio(chapter, dtoTranscript.transcript);
      await Future.delayed(Duration(milliseconds: waitTime));
      final generatedChapter = chapter.copyWith(
        content: dtoContent.content,
        transcript: dtoTranscript.transcript,
        description: dtoContent.chapterShortDescription,
        questions: questions,
      );

      final updatedChapters = state.course.chapters.map((c) {
        return c.id == chapter.id ? generatedChapter : c;
      }).toList();

      final updatedStatus = {
        ...state.chapterLoadingStatus,
        chapter.id: ChapterStatus(
          isContentGenerated: true,
          isTranscriptGenerated: true,
          isQuestionsGenerated: state.generateQuestions,
          isAudioGenerated: true,
          generationResultCode: 1,
        ),
      };

      final isAllDone = updatedStatus.values.every(
        (status) => status.generationResultCode == 1,
      );

      emit(
        state.copyWith(
          chapterLoadingStatus: updatedStatus,
          course: state.course.copyWith(chapters: updatedChapters),
          isLoadingCourse: !isAllDone,
          isCourseGenerated: isAllDone,
        ),
      );
      await Future.delayed(Duration(milliseconds: waitTime));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: "Failed to generate ${chapter.title}: $e",
          chapterLoadingStatus: {
            ...state.chapterLoadingStatus,
            chapter.id: ChapterStatus(generationResultCode: -1),
          },
        ),
      );
    }
  }

  Future<void> _onGenerateCourse(
    GenerateCourse event,
    Emitter<GenerateCourseState> emit,
  ) async {
    if (state.course.title.isEmpty) {
      emit(state.copyWith(errorMessage: "Title cannot be empty"));
      return;
    }

    if (state.course.chapters.isEmpty) {
      emit(state.copyWith(errorMessage: "Chapter titles cannot be empty"));
      return;
    }

    emit(
      state.copyWith(
        isLoadingCourse: true,
        isCourseGenerated: false,
        errorMessage: null,
        lockBottom: true,
      ),
    );

    for (final chapter in state.course.chapters) {
      add(GenerateChapter(chapter));
      Future.delayed(Duration(milliseconds: 1000));
    }
  }

  /*Future<void> _onGenerateCourse(
    GenerateCourse event,
    Emitter<GenerateCourseState> emit,
  ) async {
    const int waitTime = 1000;
    if (state.course.title.isEmpty) {
      emit(state.copyWith(errorMessage: "Title cannot be empty"));
      return;
    }

    if (state.course.chapters.isEmpty) {
      emit(state.copyWith(errorMessage: "Chapter titles cannot be empty"));
      return;
    }

    emit(
      state.copyWith(
        isLoadingCourse: true,
        isCourseGenerated: false,
        errorMessage: null,
        lockBottom: true,
      ),
    );

    final title = state.course.title;
    final language = state.course.language;
    final subtitles = state.course.chapters.map((c) => c.title).toList();

    for (final chapter in state.course.chapters) {
      emit(
        state.copyWith(
          chapterLoadingStatus: {
            ...state.chapterLoadingStatus,
            chapter.id: ChapterStatus(
              isGenerating: true,
              isContentGenerated: false,
              isTranscriptGenerated: false,
              isQuestionsGenerated: false,
              isAudioGenerated: false,
              generationResultCode: 0,
            ),
          },
        ),
      );
    }

    for (final chapter in state.course.chapters) {
      try {
        await Future.delayed(Duration(milliseconds: waitTime));
        final dtoContent = await _generateCourseContent(
          chapter,
          title,
          language,
          subtitles,
        );
        if (dtoContent is Failure<DtoChapterContent>) {
          emit(
            state.copyWith(
              errorMessage:
                  "Failed to generate content for ${chapter.title}: ${(dtoContent as Failure).message}",
              chapterLoadingStatus: {
                ...state.chapterLoadingStatus,
                chapter.id: ChapterStatus(generationResultCode: -1),
              },
            ),
          );
          return;
        }
        await Future.delayed(Duration(milliseconds: waitTime));
        final dtoTranscript = await _generateCourseTranscript(
          chapter,
          title,
          language,
          subtitles,
          dtoContent.content,
        );
        if (dtoTranscript is Failure<DtoChapterTranscript>) {
          emit(
            state.copyWith(
              errorMessage:
                  "Failed to generate transcript for ${chapter.title}: ${(dtoTranscript as Failure).message}",
              chapterLoadingStatus: {
                ...state.chapterLoadingStatus,
                chapter.id: ChapterStatus(generationResultCode: -2),
              },
            ),
          );
          return;
        }
        await Future.delayed(Duration(milliseconds: waitTime));
        List<Question> questions = [];
        if (state.generateQuestions) {
          final dtoQuestions = await _generateCourseQuestions(
            chapter,
            title,
            language,
            dtoContent.content,
          );
          if (dtoQuestions is Failure<DtoChapterQuestions>) {
            /*emit(
              state.copyWith(
                errorMessage:
                    "Failed to generate questions for ${chapter.title}: ${(dtoQuestions as Failure).message}",
                chapterLoadingStatus: {
                  ...state.chapterLoadingStatus,
                  chapter.id: ChapterStatus(generationResultCode: -3),
                },
              ),
            );*/
          } else {
            questions = dtoQuestions;
          }
        }
        //await Future.delayed(Duration(milliseconds: waitTime));
        //await _generateCourseAudio(chapter, dtoTranscript.transcript);
        await Future.delayed(Duration(milliseconds: waitTime));
        final generatedChapter = chapter.copyWith(
          content: dtoContent.content,
          transcript: dtoTranscript.transcript,
          description: dtoContent.chapterShortDescription,
          questions: questions,
        );

        final updatedChapters = state.course.chapters.map((c) {
          return c.id == chapter.id ? generatedChapter : c;
        }).toList();

        final updatedStatus = {
          ...state.chapterLoadingStatus,
          chapter.id: ChapterStatus(
            isContentGenerated: true,
            isTranscriptGenerated: true,
            isQuestionsGenerated: state.generateQuestions,
            isAudioGenerated: true,
            generationResultCode: 1,
          ),
        };

        final isAllDone = updatedStatus.values.every(
          (status) => status.generationResultCode == 1,
        );

        emit(
          state.copyWith(
            chapterLoadingStatus: updatedStatus,
            course: state.course.copyWith(chapters: updatedChapters),
            isLoadingCourse: !isAllDone,
            isCourseGenerated: isAllDone,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            errorMessage: "Failed to generate ${chapter.title}: $e",
            chapterLoadingStatus: {
              ...state.chapterLoadingStatus,
              chapter.id: ChapterStatus(generationResultCode: -1),
            },
          ),
        );
      }
    }
  }*/

  void _onClear(Clear event, Emitter<GenerateCourseState> emit) {
    emit(
      state.copyWith(
        course: state.course.copyWith(
          id: GenerateRandomId.generateRandomUUID(),
          createdAt: DateTime.now(),
          title: "",
          description: "",
          chapters: [],
        ),
        subtitle: "",
        generateQuestions: false,
        lockTop: false,
        lockBottom: true,
        isLoadingChapterTitles: false,
        isLoadingCourse: false,
        isCourseGenerated: false,
        errorMessage: null,
        chapterLoadingStatus: {},
      ),
    );
  }

  void _reOrderChapters(
    ReorderChapters event,
    Emitter<GenerateCourseState> emit,
  ) async {
    if (event.oldIndex == event.newIndex) return;
    if (event.oldIndex < event.newIndex) {
      event.newIndex -= 1;
    }
    final updatedChapters = List<Chapter>.from(state.course.chapters);
    final chapter = updatedChapters.removeAt(event.oldIndex);
    updatedChapters.insert(event.newIndex, chapter);

    emit(
      state.copyWith(course: state.course.copyWith(chapters: updatedChapters)),
    );
  }

  void _onSelectDetailLevel(SelectDetailLevel event, Emitter<GenerateCourseState> emit) {
    emit(state.copyWith(detailLevel: event.detailLevel));
  }
}
