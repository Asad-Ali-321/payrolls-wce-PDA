import React, { useEffect, useMemo, useState } from 'react';
import { MaterialReactTable, useMaterialReactTable } from 'material-react-table';
import { deleteByID, getOfficials } from 'api/official';
import ActionGroupButton from './actionGroupButton';
import ConfirmBox from 'component/ConfirmBox';
import Edit from './edit';
import { DataTableStyle } from 'component/dataTableStyle';
import TableHeader from './tableHeader';
// ==============================|| SAMPLE PAGE ||============================== //

const Officials = () => {
  const [rows, setRows] = useState([]);
  const [refresh, setRefresh] = useState(false);
  const [_delete, set_delete] = useState(false);
  const [selectedID, setSelectedID] = useState(0);
  const [edit, setEdit] = useState(false);
  const columns = useMemo(
    () => [
      {
        accessorKey: 'file_no', //access nested data with dot notation
        header: 'File#',
        size: 15
      },
      {
        accessorKey: 'official_name', //access nested data with dot notation
        header: 'Full Name',
        size: 20
      },
      {
        accessorKey: 'father_name',
        header: 'Father Name',
        size: 20
      },
      {
        accessorKey: 'designation', //normal accessorKey
        header: 'Designation',
        size: 20
      },
      {
        accessorKey: 'directorate',
        header: 'Directorate',
        size: 25
      },
      {
        accessorKey: 'chargeable_head',
        header: 'Chargeable Head',
        size: 30
      },
      {
        accessorKey: 'monthly_pay',
        header: 'Pay',
        size: 10
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
    positionActionsColumn: 'last',
    renderTopToolbar: () => <TableHeader data={rows} table={table} />,
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
      <Edit
        _id={selectedID}
        open={edit}
        onClose={() => {
          setEdit(false);
        }}
        onSuccess={() => {
          setRefresh(!refresh);
          setEdit(false);
        }}
      />
      <MaterialReactTable table={table} />
    </>
  );
};

Officials.propTypes = {};

export default Officials;
