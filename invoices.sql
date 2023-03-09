/* This is the template used by load_invoices to drop and then create the invoices table. */
drop table if exists invoices;
create table invoices(service_dt TEXT, mileage INT, invoice_number TEXT, total_invoice REAL, notes TEXT);
