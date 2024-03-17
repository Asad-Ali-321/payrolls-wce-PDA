import React, { useEffect, useMemo, useState } from 'react';
import { MaterialReactTable, useMaterialReactTable } from 'material-react-table';
import { getMonthlyPayRolls, updateRow } from 'api/Pay_Rolls';
import TableHeader from './tableHeader';
import { toast } from 'react-toastify';
import { DataTableStyle } from 'component/dataTableStyle';
const PayRolls = () => {
  const [rows, setRows] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [loadingText, setLoadingText] = useState();
  const [submitForm, setSubmitForm] = useState(false);
  const [month, setMonth] = useState('');
  const [official_id, setOfficial_id] = useState(0);

  useEffect(() => {
    setIsLoading(true);
    setLoadingText('fetching..');
    getMonthlyPayRolls(month).then((res) => {
      setRows(res);
      resetLoading();
      setOfficial_id(0);
    });
  }, [month]);

  const resetLoading = () => {
    setLoadingText('');
    setIsLoading(false);
  };

  useEffect(() => {
    if (official_id !== 0 && month != '')
      updateRow(
        month,
        rows.find((row) => row.official_id === official_id)
      ).then((res) => {
        if (res) toast.success('updated');
      });
  }, [rows]);

  const columns = useMemo(
    () => [
      {
        accessorKey: 'file_no', //access nested data with dot notation
        header: 'file_no',
        enableEditing: false
      },
      {
        accessorKey: 'official_name', //access nested data with dot notation
        header: 'employee_name',
        enableEditing: false
      },
      {
        accessorKey: 'father_name', //access nested data with dot notation
        header: 'father_name',
        enableEditing: false
      },
      {
        accessorKey: 'date_of_birth', //access nested data with dot notation
        header: 'date_of_birth',
        enableEditing: false
      },
      {
        accessorKey: 'domicile', //access nested data with dot notation
        header: 'domicile',
        enableEditing: false
      },
      {
        accessorKey: 'cnic', //access nested data with dot notation
        header: 'cnic',
        enableEditing: false
      },
      {
        accessorKey: 'address', //access nested data with dot notation
        header: 'address',
        enableEditing: false
      },
      {
        accessorKey: 'contact', //access nested data with dot notation
        header: 'contact',
        enableEditing: false
      },
      {
        accessorKey: 'designation', //access nested data with dot notation
        header: 'designation',
        enableEditing: false
      },
      {
        accessorKey: 'directorate', //access nested data with dot notation
        header: 'directorate',
        enableEditing: false
      },
      {
        accessorKey: 'chargeable_head', //access nested data with dot notation
        header: 'chargeable_head',
        enableEditing: false
      },
      {
        accessorKey: 'monthly_pay', //access nested data with dot notation
        header: 'monthly_pay',
        enableEditing: false
      },
      {
        accessorKey: 'arrears', //access nested data with dot notation
        header: 'arrears',
        enableEditing: false
      },
      {
        accessorKey: 'over_time', //access nested data with dot notation
        header: 'over_time',
        enableEditing: false
      },
      {
        accessorKey: 'income_tax', //access nested data with dot notation
        header: 'income_tax',
        enableEditing: false
      },
      {
        accessorKey: 'union_fund', //access nested data with dot notation
        header: 'union_fund',
        enableEditing: false
      },
      {
        accessorKey: 'recovery', //access nested data with dot notation
        header: 'recovery',
        enableEditing: false
      },
      {
        accessorKey: 'absentees', //access nested data with dot notation
        header: 'absentees',
        enableEditing: false
      },
      {
        accessorKey: 'absentees_amount', //access nested data with dot notation
        header: 'absentees_amount',
        enableEditing: false
      },
      {
        accessorKey: 'gross_pay', //access nested data with dot notation
        header: 'gross_pay',
        enableEditing: false
      },
      {
        accessorKey: 'deductions', //access nested data with dot notation
        header: 'deductions',
        enableEditing: false
      },
      {
        accessorKey: 'net_salary', //access nested data with dot notation
        header: 'net_salary',
        enableEditing: false
      },

      {
        accessorKey: 'bank_name', //access nested data with dot notation
        header: 'bank_name',
        enableEditing: false
      },
      {
        accessorKey: 'branch_code', //access nested data with dot notation
        header: 'branch_code',
        enableEditing: false
      },
      {
        accessorKey: 'account_number', //access nested data with dot notation
        header: 'account_number',
        enableEditing: false
      },
      {
        accessorKey: 'remarks', //access nested data with dot notation
        header: 'remarks',
        enableEditing: false
      }
    ],
    []
  );

  const table = useMaterialReactTable({
    columns,
    data: rows,
    getRowId: (row) => row.official_id,
    autoResetExpanded: true,
    enableCellActions: true,
    enableClickToCopy: 'context-menu',
    enableEditing: true,
    editDisplayMode: 'cell',
    enableStickyHeader: true,
    enableStickyFooter: true,
    ...DataTableStyle,
    renderTopToolbar: () => (
      <TableHeader
        submitForm={submitForm}
        formSubmitted={() => {
          setSubmitForm(false);
        }}
        onMonthChange={(event) => {
          setMonth(event.target.value);
        }}
        data={rows}
        table={table}
        loadingText={loadingText}
        isLoading={isLoading}
      />
    )
  });

  return <MaterialReactTable className="print-section" table={table} />;
};

PayRolls.propTypes = {};

export default PayRolls;
