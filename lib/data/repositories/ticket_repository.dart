import 'package:flutter_proyect/data/services/database/dbConnection.dart';

class TicketRepository {
  const TicketRepository(this._db);

  final AppDatabase _db;

  Future<Ticket> addTicket(double suma) async {
    Ticket ticket = await _db
        .into(_db.tickets)
        .insertReturning(TicketsCompanion.insert(totalPrice: suma));
    return ticket;
  }
}
