#!/bin/ksh93

set -x 

typeset    date
typeset -i mileage
typeset    invoice_number
typeset -F total_invoice
typeset    notes

IFS=:

cat cayenne.sql>invoices.sql 
exec 3>>invoices.sql

for file in data/*.inv
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
  print -u3 "insert into tbl1 values('$date', $mileage, '$invoice_number', $total_invoice,'"
  while read -u4 notes
  do
    print -u3 "$notes"
  done

  # Close it up
  print -u3 "');"
  exec 4<&-

done


exec 3<&-
