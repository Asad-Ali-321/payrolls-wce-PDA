import React, { useEffect, useMemo, useState } from 'react';
import { MaterialReactTable, useMaterialReactTable } from 'material-react-table';
import ActionGroupButton from './actionGroupButton';
import ConfirmBox from 'component/ConfirmBox';
import Edit from './edit';
import { DataTableStyle } from 'component/dataTableStyle';
import TableHeader from './tableHeader';
import Create from './create';
import { requestGet } from 'api/requestServer';
import { toast } from 'react-toastify';
// ==============================|| SAMPLE PAGE ||============================== //

const Directorates = () => {
  const [rows, setRows] = useState([]);
  const [refresh, setRefresh] = useState(false);
  const [_delete, set_delete] = useState(false);
  const [selectedID, setSelectedID] = useState(0);
  const [edit, setEdit] = useState(false);
  const [create, setCreate] = useState(false);

  const columns = useMemo(
    () => [
      {
        accessorKey: 'title', //access nested data with dot notation
        header: 'Title',
        size: 15
      }
    ],
    []
  );

  useEffect(() => {
    requestGet('directorates').then((res) => {
      setRows(res);
    });
  }, [refresh]);

  const table = useMaterialReactTable({
    columns,
    data: rows,
    getRowId: (row) => row.directorate_id,
    enableRowActions: true,
    enableStickyHeader: true,
    enableStickyFooter: true,
    positionActionsColumn: 'last',
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
        key={row.directorate_id}
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
    requestGet('directorates/deleteByID/' + selectedID).then(() => {
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

Directorates.propTypes = {};

export default Directorates;
