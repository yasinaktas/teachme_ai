import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/constants/app_languages.dart';
import 'package:teachme_ai/dto/dto_chapter_content.dart';
import 'package:teachme_ai/dto/dto_chapter_questions.dart';
import 'package:teachme_ai/dto/dto_chapter_transcript.dart';
import 'package:teachme_ai/dto/dto_subtitles.dart';
import 'package:teachme_ai/models/answer.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/chapter_status.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/models/question.dart';
import 'package:teachme_ai/repositories/api_result.dart';
import 'package:teachme_ai/repositories/i_generate_course_repository.dart';
import 'package:teachme_ai/repositories/i_tts_repository.dart';

class GenerateCourseBloc
    extends Bloc<GenerateCourseEvent, GenerateCourseState> {
  final IGenerateCourseRepository generateCourseRepository;
  final ITtsRepository ttsRepository;
  GenerateCourseBloc({
    required this.generateCourseRepository,
    required this.ttsRepository,
  }) : super(
         GenerateCourseState(
           course: Course(
             id: "${Random().nextInt(999999999)}",
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
    on<GenerateCourse>(_onGenerateCourse);
    on<Clear>(_onClear);
  }

  void _onSelectLanguage(
    SelectLanguage event,
    Emitter<GenerateCourseState> emit,
  ) {
    emit(
      state.copyWith(course: state.course.copyWith(language: event.language)),
    );
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
        id: "${Random().nextInt(999999)}",
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
        id: "${Random().nextInt(999999)}",
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
        2,
      );
      if (apiResult is Success) {
        final dtoSubtitles = apiResult as Success<DtoSubtitles>;
        emit(
          state.copyWith(
            course: state.course.copyWith(
              chapters: dtoSubtitles.data.subtitles.map((e) {
                return Chapter(
                  id: "${Random().nextInt(999999)}",
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
        lockBottom: true,
        errorMessage: null,
        isCourseGenerated: false,
        chapterLoadingStatus: {
          for (var chapter in state.course.chapters)
            chapter: ChapterStatus(
              isContentGenerated: false,
              isTranscriptGenerated: false,
              isQuestionsGenerated: false,
            ),
        },
      ),
    );

    try {
      for (Chapter chapter in state.course.chapters) {
        if (state.chapterLoadingStatus[chapter]!.isContentGenerated &&
            state.chapterLoadingStatus[chapter]!.isTranscriptGenerated) {
          continue;
        }
        final ApiResult<DtoChapterContent> apiResultGeneratedContent =
            await generateCourseRepository.getGeneratedChapterContent(
              state.course.title,
              state.course.language,
              chapter.title,
              40,
            );
        if (apiResultGeneratedContent is Success) {
          final ApiResult<DtoChapterTranscript> apiResultGeneratedTranscript =
              await generateCourseRepository.getGeneratedChapterTranscript(
                state.course.title,
                state.course.language,
                chapter.title,
                (apiResultGeneratedContent as Success).data.content,
              );
          if (apiResultGeneratedTranscript is Success) {
            final language = AppLanguages.languages.firstWhere(
              (lang) => lang.name == state.course.language,
            );
            await ttsRepository.generateSpeech(
              (apiResultGeneratedTranscript as Success).data.transcript,
              language.languageCode,
              language.voiceName,
              chapter.id,
            );
            emit(
              state.copyWith(
                chapterLoadingStatus: {
                  ...state.chapterLoadingStatus,
                  chapter: state.chapterLoadingStatus[chapter]!.copyWith(
                    isContentGenerated: true,
                    isTranscriptGenerated: true,
                    generationResultCode: 1,
                  ),
                },
                course: state.course.copyWith(
                  chapters: state.course.chapters.map((c) {
                    if (c.id == chapter.id) {
                      return c.copyWith(
                        content:
                            (apiResultGeneratedContent as Success).data.content,
                        transcript: (apiResultGeneratedTranscript as Success)
                            .data
                            .transcript,
                        description: (apiResultGeneratedContent as Success)
                            .data
                            .chapterShortDescription,
                      );
                    }
                    return c;
                  }).toList(),
                ),
              ),
            );
          } else {
            final errorResult =
                apiResultGeneratedTranscript as Failure<DtoChapterTranscript>;
            emit(
              state.copyWith(
                isLoadingCourse: false,
                lockBottom: false,
                errorMessage: errorResult.message,
                chapterLoadingStatus: {
                  ...state.chapterLoadingStatus,
                  chapter: state.chapterLoadingStatus[chapter]!.copyWith(
                    isContentGenerated: true,
                    isTranscriptGenerated: false,
                    generationResultCode: -2,
                  ),
                },
              ),
            );
          }
          if (state.generateQuestions) {
            final ApiResult<DtoChapterQuestions> apiResultGeneratedQuestions =
                await generateCourseRepository.generateChapterQuestions(
                  state.course.title,
                  state.course.language,
                  chapter.title,
                  (apiResultGeneratedContent as Success).data.content,
                );
            if (apiResultGeneratedQuestions is Success) {
              final List<DtoQuestion> dtoQuestions =
                  (apiResultGeneratedQuestions as Success).data.questions;
              final List<Question> questions = dtoQuestions.map((dtoQuestion) {
                final String questionId = "${Random().nextInt(999999)}";
                final List<DtoAnswer> dtoAnswers = dtoQuestion.answers;
                final List<Answer> answers = dtoAnswers.map((dtoAnswer) {
                  final String id = "${Random().nextInt(999999)}";
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
              emit(
                state.copyWith(
                  chapterLoadingStatus: {
                    ...state.chapterLoadingStatus,
                    chapter: state.chapterLoadingStatus[chapter]!.copyWith(
                      isQuestionsGenerated: true,
                      generationResultCode: 1,
                    ),
                  },
                  course: state.course.copyWith(
                    chapters: state.course.chapters.map((c) {
                      if (c.id == chapter.id) {
                        return c.copyWith(questions: questions);
                      }
                      return c;
                    }).toList(),
                  ),
                ),
              );
            } else {
              final errorResult =
                  apiResultGeneratedQuestions as Failure<DtoChapterQuestions>;
              emit(
                state.copyWith(
                  isLoadingCourse: false,
                  lockBottom: false,
                  errorMessage: errorResult.message,
                  chapterLoadingStatus: {
                    ...state.chapterLoadingStatus,
                    chapter: state.chapterLoadingStatus[chapter]!.copyWith(
                      isContentGenerated: true,
                      isTranscriptGenerated: true,
                      isQuestionsGenerated: false,
                      generationResultCode: -3,
                    ),
                  },
                ),
              );
            }
          }
        } else {
          final errorResult =
              apiResultGeneratedContent as Failure<DtoChapterContent>;
          emit(
            state.copyWith(
              isLoadingCourse: false,
              lockBottom: false,
              errorMessage: errorResult.message,
              chapterLoadingStatus: {
                ...state.chapterLoadingStatus,
                chapter: state.chapterLoadingStatus[chapter]!.copyWith(
                  isContentGenerated: false,
                  isTranscriptGenerated: false,
                  generationResultCode: -1,
                ),
              },
            ),
          );
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingCourse: false,
          lockBottom: false,
          errorMessage: "Failed to generate course: ${e.toString()}",
        ),
      );
      return;
    }

    await Future.delayed(const Duration(milliseconds: 350));

    emit(
      state.copyWith(
        isLoadingCourse: false,
        isCourseGenerated: true,
        errorMessage: null,
      ),
    );
  }

  void _onClear(Clear event, Emitter<GenerateCourseState> emit) {
    emit(
      state.copyWith(
        course: state.course.copyWith(
          id: "${Random().nextInt(999999999)}",
          createdAt: DateTime.now(),
          language: "English",
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
      ),
    );
  }
}
