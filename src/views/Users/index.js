import React, { useEffect, useMemo, useState } from 'react';
import { MaterialReactTable, useMaterialReactTable } from 'material-react-table';
import { deleteByID } from 'api/official';
import ActionGroupButton from './actionGroupButton';
import ConfirmBox from 'component/ConfirmBox';
import Edit from './edit';
import { DataTableStyle } from 'component/dataTableStyle';
import TableHeader from './tableHeader';
import { getUsers, unblockUser } from 'api/users';
import CustomConfirmBox from 'component/CustomConfirm';
import { toast } from 'react-toastify';
import Create from './create';
// ==============================|| SAMPLE PAGE ||============================== //

const Users = () => {
  const [rows, setRows] = useState([]);
  const [refresh, setRefresh] = useState(false);
  const [_create, set_create] = useState(false);
  const [_delete, set_delete] = useState(false);
  const [_unblock, set_unblock] = useState(false);
  const [selectedID, setSelectedID] = useState(0);
  const [edit, setEdit] = useState(false);

  const columns = useMemo(
    () => [
      {
        accessorKey: 'user_id', //access nested data with dot notation
        header: 'User ID',
        size: 15
      },
      {
        accessorKey: 'user_name', //access nested data with dot notation
        header: 'Full Name',
        size: 15
      },

      {
        accessorKey: 'email', //access nested data with dot notation
        header: 'Email',
        size: 20
      },
      {
        accessorKey: 'password',
        header: 'Password',
        size: 20
      },
      {
        accessorKey: 'role', //normal accessorKey
        header: 'Role',
        size: 20
      },
      {
        accessorKey: 'status',
        header: 'Status',
        size: 25
      },
      {
        accessorKey: 'attempts',
        header: 'Attempts',
        size: 30
      },
      {
        accessorKey: 'created_at',
        header: 'Created On',
        size: 10
      }
    ],
    []
  );

  useEffect(() => {
    getUsers().then((res) => {
      setRows(res);
    });
  }, [refresh]);

  const deleteRecord = async () => {
    deleteByID(selectedID).then(() => {
      set_delete(false);
      toast.info('removed');
      setRefresh(!refresh);
    });
  };

  const unBlock = async () => {
    unblockUser(selectedID).then(() => {
      set_unblock(false);
      toast.success('un blocked');
      setRefresh(!refresh);
    });
  };

  const table = useMaterialReactTable({
    columns,
    data: rows,
    getRowId: (row) => row.user_id,
    enableRowActions: true,
    enableStickyHeader: true,
    enableStickyFooter: true,

    ...DataTableStyle,
    positionActionsColumn: 'last',
    renderTopToolbar: () => (
      <TableHeader
        data={rows}
        onCreate={() => {
          set_create(true);
        }}
        table={table}
      />
    ),
    renderRowActions: ({ row }) => (
      <ActionGroupButton
        row={row}
        key={row.user_id}
        onEdit={(e) => {
          setEdit(true);
          setSelectedID(e);
        }}
        onDelete={(e) => {
          set_delete(true);
          setSelectedID(e);
        }}
        onUnblock={(e) => {
          set_unblock(true);
          setSelectedID(e);
        }}
      />
    )
  });

  return (
    <>
      <Create
        open={_create}
        onClose={() => {
          set_create(false);
        }}
        onSuccess={() => {
          setRefresh(!refresh);
          set_create(false);
        }}
      />
      <ConfirmBox
        open={_delete}
        onDisAgree={() => {
          set_delete(false);
        }}
        onAgree={() => {
          deleteRecord();
        }}
      />
      <CustomConfirmBox
        open={_unblock}
        message="Are you sure to unblock the user"
        onDisAgree={() => {
          set_unblock(false);
        }}
        onAgree={() => {
          unBlock();
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

Users.propTypes = {};

export default Users;
