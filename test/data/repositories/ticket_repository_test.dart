import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_proyect/data/repositories/ticket_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late TicketRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = TicketRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<List<Ticket>> getTickets() => db.select(db.tickets).get();

  group('TicketRepository', () {
    test('addTicket stores the total price', () async {
      final ticket = await repository.addTicket(42.5);

      expect(ticket.id, greaterThan(0));
      expect(ticket.totalPrice, 42.5);

      final tickets = await getTickets();
      expect(tickets, hasLength(1));
      expect(tickets.single.totalPrice, 42.5);
    });

    test('addTicket sets the creation timestamp', () async {
      await repository.addTicket(10.0);

      final tickets = await getTickets();
      expect(tickets.single.createdAt, isNotNull);
    });

    test('each addTicket inserts a new ticket', () async {
      await repository.addTicket(1.0);
      await repository.addTicket(2.0);
      await repository.addTicket(3.0);

      final tickets = await getTickets();
      expect(tickets, hasLength(3));
      expect(tickets.map((t) => t.totalPrice), [1.0, 2.0, 3.0]);
    });
  });
}