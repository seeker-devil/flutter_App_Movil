import 'quiz_question.dart';

const List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    id: 'q1',
    text: '¿Cuál es el propósito principal de esta capacitación?',
    options: [
      'Aprender conceptos básicos.',
      'Perder el tiempo.',
      'Jugar videojuegos.',
      'Dormir en clase.'
    ],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    id: 'q2',
    text: '¿Qué se debe hacer antes de iniciar la prueba?',
    options: [
      'Adivinar las respuestas.',
      'Revisar el material de capacitación.',
      'Cerrar la aplicación.',
      'Ignorar las instrucciones.'
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    id: 'q3',
    text: '¿Cuál es el porcentaje mínimo para aprobar?',
    options: ['50%', '60%', '70%', '100%'],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    id: 'q4',
    text: '¿Cuánto tiempo de validez tiene el certificado?',
    options: ['1 día', '30 días', '1 año', 'Para siempre'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    id: 'q5',
    text: 'Si no apruebo la prueba, ¿qué puedo hacer?',
    options: [
      'Rendirme.',
      'Intentar nuevamente.',
      'Llorar.',
      'Borrar la aplicación.'
    ],
    correctAnswerIndex: 1,
  ),
];
