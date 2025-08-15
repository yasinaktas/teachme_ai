import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/dto/dto_chapter_content.dart';
import 'package:teachme_ai/dto/dto_chapter_questions.dart';
import 'package:teachme_ai/dto/dto_chapter_transcript.dart';
import 'package:teachme_ai/dto/dto_subtitles.dart';
import 'package:teachme_ai/enums/course_detail_level.dart';
import 'package:teachme_ai/enums/course_knowledge_level.dart';
import 'package:teachme_ai/helper/generate_random_id.dart';
import 'package:teachme_ai/helper/get_error_message.dart';
import 'package:teachme_ai/models/answer.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/chapter_status.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/models/question.dart';
import 'package:teachme_ai/repositories/api_result.dart';
import 'package:teachme_ai/repositories/interfaces/i_generate_course_repository.dart';
import 'package:teachme_ai/repositories/interfaces/i_cache_repository.dart';
import 'package:teachme_ai/repositories/interfaces/i_tts_repository.dart';

class GenerateCourseBloc
    extends Bloc<GenerateCourseEvent, GenerateCourseState> {
  final IGenerateCourseRepository generateCourseRepository;
  final ITtsRepository ttsRepository;
  final ICacheRepository cacheRepository;
  GenerateCourseBloc({
    required this.generateCourseRepository,
    required this.ttsRepository,
    required this.cacheRepository,
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
    on<SelectKnowledgeLevel>(_onSelectKnowledgeLevel);
    on<SetAbout>(_onSetAbout);

    _initializeLanguage();
  }

  void _initializeLanguage() async {
    final lang = await cacheRepository.getLanguage();
    add(SelectLanguage(lang));
  }

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
        about: "",
        subtitle: "",
        generateQuestions: false,
        lockTop: false,
        lockBottom: true,
        isLoadingChapterTitles: false,
        isCourseGenerated: false,
        errorMessage: null,
        chapterLoadingStatus: {},
      ),
    );
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

  void _onSetAbout(SetAbout event, Emitter<GenerateCourseState> emit) {
    emit(state.copyWith(about: event.about, errorMessage: null));
  }

  void _onSelectLanguage(
    SelectLanguage event,
    Emitter<GenerateCourseState> emit,
  ) async {
    emit(
      state.copyWith(course: state.course.copyWith(language: event.language)),
    );
    await cacheRepository.setLanguage(event.language);
  }

  void _onSelectDetailLevel(
    SelectDetailLevel event,
    Emitter<GenerateCourseState> emit,
  ) {
    emit(state.copyWith(detailLevel: event.detailLevel));
  }

  void _onSelectKnowledgeLevel(
    SelectKnowledgeLevel event,
    Emitter<GenerateCourseState> emit,
  ) {
    emit(state.copyWith(knowledgeLevel: event.knowledgeLevel));
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

  void _onSetSubtitle(SetSubtitle event, Emitter<GenerateCourseState> emit) {
    emit(state.copyWith(subtitle: event.subtitle, errorMessage: null));
  }

  void _onAddSubtitle(AddSubtitle event, Emitter<GenerateCourseState> emit) {
    if (state.subtitle == null || state.subtitle!.isEmpty) {
      emit(state.copyWith(errorMessage: "Please enter a subtitle."));
      return;
    }
    if (state.course.chapters.length >= 10) {
      emit(state.copyWith(errorMessage: "You can add up to 10 chapters."));
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

  void _onToggleGenerateQuestions(
    ToggleGenerateQuestions event,
    Emitter<GenerateCourseState> emit,
  ) {
    emit(state.copyWith(generateQuestions: !state.generateQuestions));
  }

  Future<void> _onGenerateChapterTitles(
    GenerateChapterTitles event,
    Emitter<GenerateCourseState> emit,
  ) async {
    emit(state.copyWith(errorMessage: null));
    if (state.about.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: "Please tell us about what you want to learn.",
        ),
      );
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
        state.about,
        state.course.language,
        state.detailLevel.label,
        state.knowledgeLevel.label,
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
              title: dtoSubtitles.data.courseTitle,
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
            errorMessage: GetErrorMessage.getErrorMessage(
              errorResult.code ?? 0,
            ),
            lockTop: false,
          ),
        );
        return;
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingChapterTitles: false,
          lockTop: false,
          errorMessage: "Failed to generate chapter titles. Please try again.",
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
    String detailLevel,
    String knowledgeLevel,
  ) async {
    final ApiResult<DtoChapterContent> apiResultGeneratedContent =
        await generateCourseRepository.getGeneratedChapterContent(
          title,
          language,
          chapter.title,
          subtitles,
          detailLevel,
          knowledgeLevel,
        );
    if (apiResultGeneratedContent is Success) {
      return (apiResultGeneratedContent as Success).data;
    } else {
      // Throw yapıyor
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
      // Throw yapıyor
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
      // Throw yapıyor
      final errorResult =
          apiResultGeneratedQuestions as Failure<DtoChapterQuestions>;
      throw Exception("Failed to generate questions: ${errorResult.message}");
    }
  }

  Future<void> _onGenerateChapter(
    GenerateChapter event,
    Emitter<GenerateCourseState> emit,
  ) async {
    final chapter = event.chapter;
    final title = state.course.title;
    final language = state.course.language;
    final subtitles = state.course.chapters.map((c) => c.title).toList();
    final detailLevel = state.detailLevel.label;
    final knowledgeLevel = state.knowledgeLevel.label;
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
        errorMessage: null,
      ),
    );

    try {
      final dtoContent = await _generateCourseContent(
        chapter,
        title,
        language,
        subtitles,
        detailLevel,
        knowledgeLevel,
      );
      if (dtoContent is Failure<DtoChapterContent>) {
        emit(
          state.copyWith(
            errorMessage:
                "Failed to generate content for ${chapter.title}. Click retry button.",
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
                "Failed to generate transcript for ${chapter.title}. Click retry button.",
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
                  "Failed to generate questions for ${chapter.title}. Click retry button.",
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
          isCourseGenerated: isAllDone,
        ),
      );
      await Future.delayed(Duration(milliseconds: waitTime));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage:
              "Failed to generate ${chapter.title}. Click retry button.",
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
    emit(state.copyWith(errorMessage: null));
    if (state.course.title.isEmpty) {
      emit(state.copyWith(errorMessage: "Please add a title to the course."));
      return;
    }

    if (state.course.description.isEmpty) {
      emit(
        state.copyWith(errorMessage: "Please add a description to the course."),
      );
      return;
    }

    if (state.course.chapters.isEmpty) {
      emit(state.copyWith(errorMessage: "Please add at least one chapter."));
      return;
    }

    emit(
      state.copyWith(
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
}
