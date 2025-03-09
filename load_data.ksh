#!/usr/bin/ksh

set -x 
# We expect to receive the data name; usually cayenne or gti
data_directory=$1_data
data_type=$1

typeset    date
typeset -i mileage
typeset    invoice_number
typeset -F total_invoice
typeset    notes

IFS=:

cat invoices.sql>${data_type}_invoices.sql 
exec 3>>${data_type}_invoices.sql

for file in $data_directory/*.inv
do
  print "Processing $file"
  # For each file, read the lines
  exec 4< $file

  # For each line, step through and assign values
  read -u4 line
  set -- $line
  date=${2// /}

  read -u4 line
  set -- $line
  mileage=${2// /}

  read -u4 line
  set -- $line
  invoice_number=${2// /}

  read -u4 line
  set -- $line
  total_invoice=${2// /}

  # Throw away this line
  read -u4 line

  # Write the first portion of the insert statement
  print -u3 "insert into invoices values('$date', $mileage, '$invoice_number', $total_invoice,'"
  while read -u4 notes
  do
    print -u3 "$notes"
  done

  # Close it up
  print -u3 "');"
  exec 4<&-

done


exec 3<&-
