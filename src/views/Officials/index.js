import React, { useState } from 'react';
import { Card, CardContent, Divider, Box } from '@mui/material';
// import ActionGroupButton from './actionGroupButton';
import Edit from './edit';
import PageHeader from 'component/PageHeader';
import Create from './create';
import ConfirmBox from 'component/ConfirmBox';

import Table from './table';

// ==============================|| SAMPLE PAGE ||============================== //

const Officials = () => {
  const [create, setCreate] = useState(false);
  const [edit, setEdit] = useState(false);
  const [_delete, set_delete] = useState(false);
  const [rides_history, setRides_history] = useState(false);
  const [complaints, setComplaints] = useState(false);
  const [reviews, setReviews] = useState(false);
  const [refresh, setRefresh] = useState(true);
  // const [loading, setLoading] = useState(false);
  const [selectedID, setSelectedID] = useState(0);

  return (
    <Card>
      <>
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
          open={edit}
          onClose={() => {
            setEdit(false);
            setSelectedID(0);
          }}
          _id={selectedID}
          onSuccess={() => {
            setRefresh(!refresh);
            setEdit(false);
            setSelectedID(0);
          }}
        />
        <Edit
          open={rides_history}
          onClose={() => {
            setRides_history(false);
          }}
          onSuccess={() => {}}
        />
        <Edit
          open={complaints}
          onClose={() => {
            setComplaints(false);
          }}
          onSuccess={() => {}}
        />
        <Edit
          open={reviews}
          onClose={() => {
            setReviews(false);
          }}
          onSuccess={() => {}}
        />
        <ConfirmBox
          open={_delete}
          onDisAgree={() => {
            set_delete(false);
          }}
          onAgree={() => {
            DeleteRecord();
          }}
        />
      </>
      <PageHeader
        title="Officials List"
        onCreate={() => {
          setCreate(true);
        }}
      />

      <Divider />

      <CardContent>
        <Box sx={{ width: '100%', textAlign: 'center' }}>
          <Table />
        </Box>
      </CardContent>
    </Card>
  );
};

export default Officials;
