import { Box, Card, CardContent, CardHeader, Divider, Grid, LinearProgress, TextField, Typography } from '@mui/material';
import { getMonthlyPayRolls } from 'api/Pay_Rolls';
import { useEffect, useRef, useState } from 'react';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import { useNavigate, useParams } from 'react-router';
import { currentMonth } from 'api/customFunction';
import PrintButton from 'component/PrintButton';

export const Print = () => {
  const { month } = useParams();
  const navigate = useNavigate();
  const [rows, setRows] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [loadingText, setLoadingText] = useState();
  const [selectedMonth, setSelectedMonth] = useState(month);

  const ref = useRef();

  const resetLoading = () => {
    setLoadingText('');
    setIsLoading(false);
  };

  useEffect(() => {
    setIsLoading(true);
    setLoadingText('fetching..');
    if (month)
      getMonthlyPayRolls(month).then((res) => {
        setRows(res);
      });
    resetLoading();
  }, [month]);

  useEffect(() => {
    navigate('/pay-rolls/print/' + selectedMonth);
  }, [selectedMonth]);

  return (
    <Grid container>
      <Grid item>
        <Card>
          <CardHeader
            title={
              <Box display="flex" justifyContent="space-between" alignItems="center">
                <Typography component="div" className="card-header">
                  <TextField
                    required
                    size="large"
                    onChange={(e) => {
                      setSelectedMonth(e.target.value);
                    }}
                    inputProps={{ max: currentMonth() }}
                    style={{ marginLeft: 10 }}
                    variant="standard"
                    type="month"
                    value={selectedMonth}
                  />
                </Typography>
                <div>PAY-ROLL FOR THE MONTH OF {month}</div>
                <div>
                  <PrintButton content={() => ref.current} />
                </div>
              </Box>
            }
          />
          <Divider />

          <CardContent>
            {isLoading ? (
              <>
                <LinearProgress /> {loadingText}
              </>
            ) : (
              <>
                <Typography variant="body2" ref={ref}>
                  <TableContainer component={Paper}>
                    <Table size="small">
                      <TableHead sx={{ '&&&': { '& td, & th': { padding: 1, margin: 0 } } }}>
                        <TableRow>
                          <TableCell sx={{ fontSize: 36 }} colSpan={12} align="center">
                            WORK CHARGE EMPLOYEES PAY-ROLL FOR THE MONTH OF : {month}
                          </TableCell>
                        </TableRow>
                        <TableRow>
                          <TableCell align="center">S.no</TableCell>
                          <TableCell align="left">cnic</TableCell>
                          <TableCell align="left">Official Name</TableCell>
                          <TableCell align="left">Father Name</TableCell>
                          <TableCell align="left">Designation</TableCell>
                          <TableCell align="left">Directorate</TableCell>
                          <TableCell align="left">Chargeable Head</TableCell>
                          <TableCell align="left">Monthly Pay</TableCell>
                          <TableCell align="left">Attendance</TableCell>
                          <TableCell align="left">Income Tax</TableCell>
                          <TableCell align="left">Deductions</TableCell>
                          <TableCell align="left">Remarks</TableCell>
                        </TableRow>
                      </TableHead>
                      <TableBody sx={{ '&&&': { '& td, & th': { padding: 1, margin: 0 } } }}>
                        {rows.map((row, index) => (
                          <TableRow key={row.cnic} sx={{ '&:last-child td, &:last-child th': { border: 0 } }}>
                            <TableCell align="center">{index + 1}</TableCell>
                            <TableCell component="th" scope="row">
                              {row.cnic}
                            </TableCell>
                            <TableCell align="left">{row.official_name}</TableCell>
                            <TableCell align="left">{row.father_name}</TableCell>
                            <TableCell align="left">{row.designation}</TableCell>
                            <TableCell align="left">{row.directorate}</TableCell>
                            <TableCell align="left">{row.chargeable_head}</TableCell>
                            <TableCell align="left">{row.monthly_pay}</TableCell>
                            <TableCell align="left">{row.attendance}</TableCell>
                            <TableCell align="left">{row.income_tax}</TableCell>
                            <TableCell align="left">{row.deductions}</TableCell>
                            <TableCell align="left">{row.remarks}</TableCell>
                          </TableRow>
                        ))}
                      </TableBody>
                    </Table>
                  </TableContainer>
                </Typography>
              </>
            )}
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );
};
