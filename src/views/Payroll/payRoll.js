import { Box, Button, CircularProgress, Grid, LinearProgress, Stack, TextField } from '@mui/material';
import * as React from 'react';
import LibraryAddCheckIcon from '@mui/icons-material/LibraryAddCheck';
import { requestPost } from 'api/requestServer';
import LineHeading from 'component/LineHeading';
import PropTypes from 'prop-types';
import { useTheme } from '@emotion/react';
import { defaultInputProps } from 'component/config';
import { currentMonth, daysCountInMonth } from 'api/customFunction';
import { toast } from 'react-toastify';
export const PayRoll = (props) => {
  const { isFetching, filterData } = props;
  const theme = useTheme();
  const [loading, setLoading] = React.useState(false);
  const [payRollData, setPayRollData] = React.useState([]);
  const month = currentMonth();

  const handleInputChange = async () => {
    const { name, value } = event.target;
    setPayRollData({ ...payRollData, [name]: value });
  };

  const calculatePayRoll = () => {
    const grossPay = getGrossPay();
    const deductions = getDeductions();
    const absenteesAmount = getAbsenteesAmount();
    setPayRollData({
      ...payRollData,
      gross_pay: grossPay,
      deductions: deductions,
      absentees_amount: absenteesAmount,
      net_salary: grossPay - deductions
    });
  };

  const getGrossPay = () => {
    return (
      parseInt(payRollData.monthly_pay ? payRollData.monthly_pay : 0) +
      parseInt(payRollData.arrears ? payRollData.arrears : 0) +
      parseInt(payRollData.over_time ? payRollData.over_time : 0)
    );
  };

  const getDeductions = () => {
    return (
      parseInt(payRollData.income_tax ? payRollData.income_tax : 0) +
      parseInt(payRollData.union_fund ? payRollData.union_fund : 0) +
      parseInt(payRollData.recovery ? payRollData.recovery : 0) +
      parseInt(getAbsenteesAmount())
    );
  };

  const getAbsenteesAmount = () => {
    const monthly_pay = payRollData.monthly_pay;
    const absentees = payRollData.absentees;
    const daysInMonth = daysCountInMonth(month);
    return Math.round((monthly_pay / daysInMonth) * absentees);
  };

  React.useEffect(() => {
    calculatePayRoll();
  }, [payRollData]);

  React.useEffect(() => {
    setPayRollData(filterData);
  }, [filterData]);
  const handleSubmit = async (event) => {
    setLoading(false);
    event.preventDefault();
    setLoading(true);

    payRollData.month = month;
    requestPost('Pay_Rolls/create', payRollData).then(async (res) => {
      debugger;
      if (res.code != 0) toast.warning(res.message);
      else {
        toast.success('updated');
      }
      setLoading(false);
    });
  };
  return (
    <form onSubmit={handleSubmit}>
      {isFetching ? (
        <LinearProgress />
      ) : (
        <>
          <Grid container spacing={2}>
            <Grid item lg={4} xs={12}>
              <LineHeading heading={'ALLOWANCES'} color={'primary'} />
              <TextField
                {...defaultInputProps}
                label="monthly_pay"
                type="number"
                style={{ marginTop: '14px' }}
                required
                InputLabelProps={{ shrink: true }}
                name="monthly_pay"
                onChange={handleInputChange}
                value={payRollData.monthly_pay ? payRollData.monthly_pay : 0}
              />
              <TextField
                {...defaultInputProps}
                label="arrears"
                type="number"
                style={{ marginTop: '14px' }}
                required
                InputLabelProps={{ shrink: true }}
                name="arrears"
                onChange={handleInputChange}
                value={payRollData.arrears ? payRollData.arrears : 0}
              />

              <TextField
                {...defaultInputProps}
                label="over_time"
                type="number"
                style={{ marginTop: '14px' }}
                required
                InputLabelProps={{ shrink: true }}
                name="over_time"
                onChange={handleInputChange}
                value={payRollData.over_time ? payRollData.over_time : 0}
              />

              <TextField
                {...defaultInputProps}
                label="account_number"
                type="number"
                sx={{
                  marginTop: '14px',
                  '& .MuiOutlinedInput-root': {
                    fontWeight: '600'
                  }
                }}
                disabled
                InputLabelProps={{ shrink: true }}
                name="account_number"
                onChange={handleInputChange}
                value={payRollData.account_number ? payRollData.account_number : '-'}
              />
            </Grid>
            <Grid item lg={4} xs={12}>
              <LineHeading heading={'DEDUCTIONS'} color={'primary'} />
              <TextField
                {...defaultInputProps}
                label="income_tax"
                type="number"
                style={{ marginTop: '14px' }}
                required
                InputLabelProps={{ shrink: true }}
                name="income_tax"
                onChange={handleInputChange}
                value={payRollData.income_tax ? payRollData.income_tax : 0}
              />
              <TextField
                {...defaultInputProps}
                label="union_fund"
                type="number"
                style={{ marginTop: '14px' }}
                required
                InputLabelProps={{ shrink: true }}
                name="union_fund"
                onChange={handleInputChange}
                value={payRollData.union_fund ? payRollData.union_fund : 0}
              />
              <TextField
                {...defaultInputProps}
                label="recovery"
                type="number"
                style={{ marginTop: '14px' }}
                required
                InputLabelProps={{ shrink: true }}
                name="recovery"
                onChange={handleInputChange}
                value={payRollData.recovery ? payRollData.recovery : 0}
              />

              <Grid container spacing={2}>
                <Grid item lg={6} xs={12}>
                  <TextField
                    {...defaultInputProps}
                    label="absentees"
                    type="number"
                    style={{ marginTop: '14px' }}
                    required
                    InputLabelProps={{ shrink: true }}
                    name="absentees"
                    onChange={handleInputChange}
                    value={payRollData.absentees ? payRollData.absentees : 0}
                  />
                </Grid>
                <Grid item lg={6} xs={12}>
                  <TextField
                    {...defaultInputProps}
                    label="absentees_amount"
                    type="number"
                    style={{ marginTop: '14px' }}
                    disabled
                    InputLabelProps={{ shrink: true }}
                    name="absentees_amount"
                    onChange={handleInputChange}
                    value={payRollData.absentees_amount ? payRollData.absentees_amount : 0}
                  />
                </Grid>
              </Grid>
            </Grid>
            <Grid item lg={4} xs={12}>
              <LineHeading heading={'PAYROLL'} color={'primary'} />
              <TextField
                {...defaultInputProps}
                label="gross_pay"
                type="number"
                disabled
                sx={{
                  marginTop: '14px',
                  '& .MuiOutlinedInput-root': {
                    fontWeight: '600'
                  }
                }}
                InputLabelProps={{ shrink: true }}
                required
                name="gross_pay"
                onChange={handleInputChange}
                value={payRollData.gross_pay ? payRollData.gross_pay : 0}
              />
              <TextField
                {...defaultInputProps}
                label="deductions"
                type="number"
                disabled
                sx={{
                  marginTop: '14px',
                  '& .MuiOutlinedInput-root': {
                    fontWeight: '600'
                  }
                }}
                InputLabelProps={{ shrink: true }}
                required
                name="deductions"
                onChange={handleInputChange}
                value={payRollData.deductions ? payRollData.deductions : 0}
              />
              <TextField
                {...defaultInputProps}
                label="net_salary"
                type="number"
                disabled
                sx={{
                  marginTop: '14px',
                  '& .MuiOutlinedInput-root': {
                    fontWeight: '600'
                  }
                }}
                InputLabelProps={{ shrink: true }}
                required
                name="net_salary"
                onChange={handleInputChange}
                value={payRollData.net_salary ? payRollData.net_salary : 0}
              />

              <TextField
                {...defaultInputProps}
                label="bank_name"
                type="text"
                sx={{
                  marginTop: '14px',
                  '& .MuiOutlinedInput-root': {
                    fontWeight: '600'
                  }
                }}
                disabled
                InputLabelProps={{ shrink: true }}
                name="bank_name"
                onChange={handleInputChange}
                value={payRollData.bank_name ? payRollData.bank_name : '-'}
              />
            </Grid>
            <Grid item lg={12} xs={12}>
              <TextField
                {...defaultInputProps}
                label="remarks"
                InputLabelProps={{ shrink: true }}
                type="text"
                style={{ marginTop: '14px' }}
                name="remarks"
                onChange={handleInputChange}
                value={payRollData.remarks ? payRollData.remarks : ''}
              />
            </Grid>
          </Grid>
          <Box mt={5}>
            <hr />
            <Stack direction={'row'} justifyContent="space-between" mt={1}>
              <Button
                title="Update"
                disabled={loading}
                variant="contained"
                type="submit"
                fullWidth={true}
                style={{ background: theme.palette.primary.light }}
                size="medium"
              >
                {loading ? <CircularProgress /> : <LibraryAddCheckIcon />} Update
              </Button>
            </Stack>
          </Box>
        </>
      )}
    </form>
  );
};

PayRoll.propTypes = {
  filterData: PropTypes.any,
  isFetching: PropTypes.bool
};

PayRoll.defaultProps = {
  filterData: {}
};

export default PayRoll;
