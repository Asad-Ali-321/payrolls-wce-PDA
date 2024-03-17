import * as React from 'react';
import { Card, CardContent, Grid } from '@mui/material';
import SearchSection from './searchSection';
import PayRoll from './payRoll';
import { getEmployeePayroll } from 'api/Pay_Rolls';

const PayRollCreate = () => {
  const [userData, setUserData] = React.useState({});

  const [isFetching, setIsFetching] = React.useState(false);

  const fetchEmployeePayroll = (file_no, cnic, month) => {
    setIsFetching(true);
    getEmployeePayroll(file_no, cnic, month).then((res) => {
      debugger
      if (res) setUserData(res);
      else {
        setUserData({});
        console.log('userData', userData);
      }
      setIsFetching(false);
    });
  };

  return (
    <Grid container>
      <Grid item>
        <Card>
          <CardContent>
            <SearchSection fetchEmployeePayroll={fetchEmployeePayroll} isFetching={isFetching} filterData={userData} />
            <hr />
            <PayRoll filterData={userData} isFetching={isFetching} />
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );
};

PayRollCreate.propTypes = {};

export default PayRollCreate;
