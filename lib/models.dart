class TicketModel {
  final String id;
  final String problemType;
  final String location;
  final String equipment;
  final String description;
  final TicketStatus status;
  final DateTime createdAt;

  const TicketModel({
    required this.id,
    required this.problemType,
    required this.location,
    required this.equipment,
    this.description = '',
    this.status = TicketStatus.received,
    required this.createdAt,
  });
}

enum TicketStatus { received, analyzing, techOnWay, resolved }

class ProblemType {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final int colorIndex;

  const ProblemType({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colorIndex,
  });
}

class LocationOption {
  final String id;
  final String name;
  final String icon;

  const LocationOption({
    required this.id,
    required this.name,
    required this.icon,
  });
}

final List<ProblemType> problemTypes = [
  const ProblemType(
      id: 'wifi',
      title: 'Não consigo acessar o Wi-Fi',
      subtitle: 'Problemas de conexão ou senha inválida.',
      icon: 'wifi',
      colorIndex: 0),
  const ProblemType(
      id: 'pc',
      title: 'Computador não funciona',
      subtitle: 'Equipamento não liga ou está muito lento.',
      icon: 'computer',
      colorIndex: 1),
  const ProblemType(
      id: 'portal',
      title: 'Portal acadêmico indisponível',
      subtitle: 'Erro ao logar ou sistema fora do ar.',
      icon: 'public',
      colorIndex: 2),
  const ProblemType(
      id: 'printer',
      title: 'Problema na impressora',
      subtitle: 'Atolamento de papel ou falta de toner.',
      icon: 'print',
      colorIndex: 3),
  const ProblemType(
      id: 'projector',
      title: 'Projetor não funciona',
      subtitle: 'Sem imagem ou cores distorcidas em sala.',
      icon: 'videocam',
      colorIndex: 4),
  const ProblemType(
      id: 'other',
      title: 'Outro problema',
      subtitle: 'Descreva sua necessidade específica.',
      icon: 'help',
      colorIndex: 5),
];

final List<LocationOption> locationOptions = [
  const LocationOption(
      id: 'library', name: 'Biblioteca', icon: 'library_books'),
  const LocationOption(id: 'lab1', name: 'Laboratório 1', icon: 'science'),
  const LocationOption(id: 'lab2', name: 'Laboratório 2', icon: 'biotech'),
  const LocationOption(id: 'classroom', name: 'Sala de aula', icon: 'school'),
  const LocationOption(id: 'other', name: 'Outro local', icon: 'more_horiz'),
];
