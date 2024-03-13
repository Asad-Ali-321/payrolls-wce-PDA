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

  const handleAttendanceChanged = (official_id, value) => {
    setSubmitForm(true);
    setRows((prevRows) =>
      prevRows.map((row) => {
        if (row.official_id === official_id) return { ...row, attendance: value };
        return row;
      })
    );
    setOfficial_id(official_id);
    resetLoading();
  };

  const handleDeductionChanged = async (official_id, value) => {
    setSubmitForm(true);
    setRows((prevRows) =>
      prevRows.map((row) => {
        if (row.official_id === official_id) return { ...row, deductions: value, net_salary: row.monthly_pay - row.income_tax - value };
        return row;
      })
    );
    setOfficial_id(official_id);
    resetLoading();
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
        accessorKey: 'cnic', //access nested data with dot notation
        header: 'cnic#',
        enableEditing: false
      },
      {
        accessorKey: 'official_name', //access nested data with dot notation
        header: 'Full Name',
        enableEditing: false
      },
      {
        accessorKey: 'father_name', //access nested data with dot notation
        header: 'Father Name',
        enableEditing: false
      },
      {
        accessorKey: 'designation', //normal accessorKey
        header: 'Designation',
        enableEditing: false
      },
      {
        accessorKey: 'directorate',
        header: 'Directorate',
        enableEditing: false
      },
      {
        accessorKey: 'monthly_pay',
        header: 'Basic Pay',
        enableEditing: false,
        size: 15
      },
      {
        accessorKey: 'income_tax',
        header: 'Income Tax',
        enableEditing: false,
        size: 15
      },
      {
        accessorKey: 'attendance',
        header: 'Days Attended',
        size: 15,
        muiEditTextFieldProps: ({ row }) => ({
          type: 'number',
          onBlur: (event) => {
            setIsLoading(true);
            setLoadingText('updating..');
            handleAttendanceChanged(row.id, event.target.value);
          }
        })
      },
      {
        accessorKey: 'deductions',
        header: 'Deductions',
        size: 15,
        muiEditTextFieldProps: ({ row }) => ({
          type: 'number',
          onBlur: (event) => {
            setIsLoading(true);
            setLoadingText('updating..');
            handleDeductionChanged(row.id, event.target.value);
          }
        })
      },

      {
        accessorKey: 'net_salary',
        header: 'Net Salary',
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
