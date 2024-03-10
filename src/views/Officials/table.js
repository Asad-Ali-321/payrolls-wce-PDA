import React, { useEffect, useMemo, useState } from 'react';

import { MaterialReactTable, useMaterialReactTable } from 'material-react-table';
import { getOfficials } from 'api/official';
import ActionGroupButton from './actionGroupButton';

// ==============================|| SAMPLE PAGE ||============================== //

const Table = () => {
  const [rows, setRows] = useState([]);
  const columns = useMemo(
    () => [
      {
        accessorKey: 'official_name', //access nested data with dot notation
        header: 'Full Name'
      },
      {
        accessorKey: 'father_name',
        header: 'Father Name'
      },
      {
        accessorKey: 'designation', //normal accessorKey
        header: 'Designation'
      },
      {
        accessorKey: 'directorate',
        header: 'Directorate'
      },
      {
        accessorKey: 'chargeable_head',
        header: 'Chargeable Head'
      },
      {
        accessorKey: 'monthly_pay',
        header: 'Pay'
      }
    ],
    []
  );
  ////Fetch Data
  useEffect(() => {
    // setLoading(true);
    getOfficials().then((res) => {
      if (res.status) setRows(res.data);
    });
  }, []);

  const table = useMaterialReactTable({
    columns,
    data: rows,
    enableRowSelection: true,
    getRowId: (row) => row.user_id,
    autoResetExpanded: true,
    muiPaginationProps: {
      rowsPerPageOptions: [50, 100, 200]
    },
    initialState: { pagination: { pageSize: 50 }, density: 'comfortable' },
    muiTableBodyCellProps: {
      //simple styling with the `sx` prop, works just like a style prop in this example
      sx: {
        fontWeight: 'normal',
        fontSize: '0.8rem',
        padding: '0px'
      }
    },
    muiTableHeadCellProps: {
      //simple styling with the `sx` prop, works just like a style prop in this example
      sx: {
        fontWeight: 'Bold',
        fontSize: '0.9rem',
        padding: '0px'
      }
    },
    muiTableBodyProps: {
      sx: {
        '& tr > td': {
          backgroundColor: 'white'
        }
      }
    },
    muiTableHeadProps: {
      sx: {
        '& tr > th': {
          backgroundColor: 'white'
        }
      }
    },
    enableRowActions: true,
    positionActionsColumn: 'last',
    renderRowActions: ({ row }) => (
      <ActionGroupButton
        row={row}
        key={row.user_id}
        onEdit={(e) => {
          alert(e);
        }}
        onDelete={(e) => {
          alert(e);
        }}
      />
    )
  });

  return <MaterialReactTable table={table} />;
};

export default Table;
