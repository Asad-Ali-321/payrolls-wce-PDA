import React, { useEffect, useMemo, useState } from 'react';
import { MaterialReactTable, useMaterialReactTable } from 'material-react-table';
import { deleteByID, getOfficials } from 'api/official';
import ActionGroupButton from './actionGroupButton';
import ConfirmBox from 'component/ConfirmBox';
import Edit from './edit';
import { DataTableStyle } from 'component/dataTableStyle';
import TableHeader from './tableHeader';
import { Chip } from '@mui/material';
import Create from './create';
import { toast } from 'react-toastify';
// ==============================|| SAMPLE PAGE ||============================== //

const Officials = () => {
  const [rows, setRows] = useState([]);
  const [refresh, setRefresh] = useState(false);
  const [_delete, set_delete] = useState(false);
  const [selectedID, setSelectedID] = useState(0);
  const [edit, setEdit] = useState(false);
  const [create, setCreate] = useState(false);

  const columns = useMemo(
    () => [
      {
        accessorKey: 'valid_upto', //access nested data with dot notation
        header: 'validity_upto',
        size: 15
      },
      {
        accessorKey: 'file_no', //access nested data with dot notation
        header: 'file_no',
        size: 15
      },
      {
        accessorKey: 'official_name', //access nested data with dot notation
        header: 'official_name',
        size: 15
      },
      {
        accessorKey: 'father_name', //access nested data with dot notation
        header: 'father_name',
        size: 15
      },
      {
        accessorKey: 'date_of_birth', //access nested data with dot notation
        header: 'date_of_birth',
        size: 15
      },
      {
        accessorKey: 'domicile', //access nested data with dot notation
        header: 'domicile',
        size: 15
      },
      {
        accessorKey: 'cnic', //access nested data with dot notation
        header: 'cnic',
        size: 15
      },
      {
        accessorKey: 'address', //access nested data with dot notation
        header: 'address',
        size: 15
      },
      {
        accessorKey: 'contact', //access nested data with dot notation
        header: 'contact',
        size: 15
      },
      {
        accessorKey: 'appointment_date', //access nested data with dot notation
        header: 'appointment_date',
        size: 15
      },
      {
        accessorKey: 'designation', //access nested data with dot notation
        header: 'designation',
        size: 15
      },
      {
        accessorKey: 'directorate', //access nested data with dot notation
        header: 'directorate',
        size: 15
      },
      {
        accessorKey: 'chargeable_head', //access nested data with dot notation
        header: 'chargeable_head',
        size: 15
      },
      {
        accessorKey: 'monthly_pay', //access nested data with dot notation
        header: 'Fix Pay',
        size: 15
      },
      {
        accessorKey: 'income_tax_applied', //access nested data with dot notation
        header: 'Income Tax',
        size: 15,
        Cell: ({ cell }) => {
          return (
            <Chip
              size="small"
              color={cell.getValue() == 1 ? 'primary' : 'default'}
              label={cell.getValue() == 1 ? <span>applied</span> : ''}
            ></Chip>
          );
        }
      },
      {
        accessorKey: 'is_salary_blocked', //access nested data with dot notation
        header: 'Salary Blocked',
        size: 15,
        Cell: ({ cell }) => {
          return (
            <Chip
              size="small"
              color={cell.getValue() == 1 ? 'warning' : 'default'}
              label={cell.getValue() == 1 ? <span>blocked</span> : ''}
            ></Chip>
          );
        }
      },

      {
        accessorKey: 'bank_name', //access nested data with dot notation
        header: 'bank_name',
        size: 15
      },
      {
        accessorKey: 'branch_name', //access nested data with dot notation
        header: 'branch_name',
        size: 15
      },
      {
        accessorKey: 'branch_code', //access nested data with dot notation
        header: 'branch_code',
        size: 15
      },
      {
        accessorKey: 'account_number', //access nested data with dot notation
        header: 'account_number',
        size: 15
      },
      {
        accessorKey: 'created_at', //access nested data with dot notation
        header: 'created_at',
        size: 15
      }
    ],
    []
  );

  useEffect(() => {
    getOfficials().then((res) => {
      setRows(res);
    });
  }, [refresh]);

  const table = useMaterialReactTable({
    columns,
    data: rows,
    getRowId: (row) => row.official_id,
    enableRowActions: true,
    enableStickyHeader: true,
    enableStickyFooter: true,

    ...DataTableStyle,
    renderTopToolbar: () => (
      <TableHeader
        data={rows}
        onCreate={() => {
          setCreate(true);
        }}
        table={table}
      />
    ),
    renderRowActions: ({ row }) => (
      <ActionGroupButton
        row={row}
        key={row.official_id}
        onEdit={(e) => {
          setEdit(true);
          setSelectedID(e);
        }}
        onDelete={(e) => {
          set_delete(true);
          setSelectedID(e);
        }}
      />
    )
  });

  const DeleteRecord = async () => {
    deleteByID(selectedID).then(() => {
      set_delete(false);
      toast.info('removed');
      setRefresh(!refresh);
    });
  };

  return (
    <>
      <ConfirmBox
        open={_delete}
        onDisAgree={() => {
          set_delete(false);
        }}
        onAgree={() => {
          DeleteRecord();
        }}
      />
      <Create
        open={create}
        onClose={() => {
          setCreate(false);
        }}
        onSuccess={() => {
          setRefresh(!refresh);
          setCreate(false);
        }}
      />
      <Edit
        _id={selectedID}
        open={edit}
        onClose={() => {
          setEdit(false);
          setSelectedID(0);
        }}
        onSuccess={() => {
          setRefresh(!refresh);
          setEdit(false);
          setSelectedID(0);
        }}
      />
      <MaterialReactTable table={table} />
    </>
  );
};

Officials.propTypes = {};

export default Officials;
