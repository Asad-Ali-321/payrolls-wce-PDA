import { Box,  CircularProgress, TextField, Typography } from '@mui/material';
import PropTypes from 'prop-types';
import {
  MRT_GlobalFilterTextField,
  MRT_ShowHideColumnsButton,
  MRT_ToggleDensePaddingButton,
  MRT_ToggleFiltersButton
} from 'material-react-table';
import { useEffect, useRef } from 'react';
import { currentMonth } from 'api/customFunction';
import ExportCSVButton from 'component/ExportCSV';

const TableHeader = (props) => {
  const { table, isLoading, loadingText, submitForm, formSubmitted, onMonthChange, data } = props;
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
        <div display="flex">
          <MRT_GlobalFilterTextField style={{ float: 'right', textAlign: 'center', marginLeft: '0.5rem' }} table={table} />
        </div>
        <div>
          <ExportCSVButton data={data} fileName="payroll" />
          <MRT_ToggleDensePaddingButton table={table} />
          <MRT_ToggleFiltersButton table={table} />
          <MRT_ShowHideColumnsButton table={table} />
          {isLoading ? (
            <div style={{ float: 'right', textAlign: 'center', marginLeft: '0.5rem' }}>
              <CircularProgress size={'1rem'} />
              <Typography color={'primary'}> {loadingText}</Typography>
            </div>
          ) : (
            ''
          )}
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
