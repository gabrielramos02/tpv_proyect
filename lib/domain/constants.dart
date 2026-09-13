/// Phantom table that hosts the split-table order. Used as the `restTable`
/// id of split orders so they can be queried and checked out separately from
/// real tables. No `RestTable` row with this id is ever created.
const int phantomTableId = 99;

/// Product type filter used for "all types" (Todos) in the product picker.
const int allProductTypesId = 99;

/// Placeholder product id for the free-price "Varios" button.
const int variosProductId = 99;