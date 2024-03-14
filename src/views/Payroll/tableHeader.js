import { Box, Button, CircularProgress, Divider, TextField, Typography } from '@mui/material';
import PropTypes from 'prop-types';
import { MRT_GlobalFilterTextField, MRT_ShowHideColumnsButton } from 'material-react-table';
import PrintIcon from '@mui/icons-material/Print';
import { useEffect, useRef } from 'react';
import { currentMonth } from 'api/customFunction';
import ExportCSVButton from 'component/ExportCSV';
import { useNavigate } from 'react-router';

const TableHeader = (props) => {
  const { table, isLoading, loadingText, submitForm, formSubmitted, onMonthChange, data } = props;
  const navigate = useNavigate();
  const submitButtonRef = useRef(null);

  const maxMonth = currentMonth();

  const handleSubmit = async (event) => {
    event.preventDefault();
    // Your form submission logic here
  };

  useEffect(() => {
    if (submitForm) submitButtonRef.current.click();

    formSubmitted(false);
  }, [submitForm]);

  return (
    <>
      <Box display="flex" style={{ margin: '0.5rem 1.5rem' }} justifyContent="space-between" alignItems="center">
        <div display="flex">
          <form onSubmit={handleSubmit}>
            <Typography variant="h6" style={{ float: 'left' }}>
              Pay Roll Month:
            </Typography>
            <TextField
              required
              size=""
              onChange={onMonthChange}
              inputProps={{ max: maxMonth }}
              style={{ marginLeft: 10 }}
              variant="standard"
              type="month"
            ></TextField>
            <button type="submit" ref={submitButtonRef} hidden>
              as
            </button>
          </form>
        </div>

        <div>
          {isLoading ? (
            <Typography color={'primary'} mt={1} style={{ float: 'right', textAlign: 'center', marginLeft: '0.5rem' }}>
              <CircularProgress size={'1rem'} />
              {loadingText}
            </Typography>
          ) : (
            ''
          )}
        </div>
        <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
          <Button
            startIcon={<PrintIcon />}
            onClick={() => {
              navigate('/pay-rolls/print/' + maxMonth);
            }}
          >
            Print
          </Button>
          <Divider orientation="vertical" style={{ margin: '0px 8px' }} flexItem />
          <ExportCSVButton data={data} fileName="payroll" />
          <Divider orientation="vertical" style={{ margin: '0px 8px' }} flexItem />
          <MRT_GlobalFilterTextField table={table} />
          <Divider orientation="vertical" style={{ margin: '0px 8px' }} flexItem />
          <MRT_ShowHideColumnsButton table={table} />
        </div>
      </Box>
    </>
  );
};

TableHeader.propTypes = {
  table: PropTypes.any,
  isLoading: PropTypes.bool,
  loadingText: PropTypes.string,
  submitForm: PropTypes.bool,
  formSubmitted: PropTypes.func,
  onMonthChange: PropTypes.func,
  data: PropTypes.any
};

export default TableHeader;
