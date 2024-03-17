import * as React from 'react';
import PropTypes from 'prop-types';
import { CircularProgress, Grid, TextField, Typography } from '@mui/material';
import { defaultInputProps } from 'component/config';
import { UploadFile } from 'component/uploadButton';
import TextMask from 'component/TextMask';
import { currentMonth } from 'api/customFunction';

const SearchSection = (props) => {
  const { filterData, fetchEmployeePayroll, isFetching } = props;
  const maxMonth = currentMonth();
  const [data, setData] = React.useState({ file_no: '', cnic: '', month: maxMonth });

  const handleInputChange = (event) => {
    const { name, value } = event.target;
    setData({ ...data, [name]: value });
  };

  React.useEffect(() => {
    fetchEmployeePayroll(data.file_no, data.cnic, data.month);
  }, [data]);

  return (
    <Grid container spacing={2}>
      <Grid
        item
        lg={3}
        xs={12}
        style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          textAlign: 'center'
        }}
      >
        <Typography variant="h6" color={'primary'}>
          CREATE/ UPDATE PAYROLL
        </Typography>
        <UploadFile
          disabled={true}
          onFileChange={() => {
            // setFile(target);
          }}
        />
      </Grid>
      <Grid item lg={1} xs={12} style={{ display: 'flex', alignItems: 'center' }}>
        {!isFetching ? '' : <CircularProgress />}
      </Grid>
      <Grid item lg={3} xs={12}>
        <TextField
          {...defaultInputProps}
          label="File#"
          autoFocus
          type="text"
          required
          tabIndex={0}
          style={{ marginTop: '14px' }}
          name="file_no"
          value={data.file_no}
          onChange={handleInputChange}
        />
        <TextField
          {...defaultInputProps}
          label="Employee Name"
          type="text"
          disabled
          style={{ marginTop: '14px' }}
          required
          InputLabelProps={{ shrink: true }}
          name="official_name"
          value={filterData.official_name ? filterData.official_name : ''}
        />
        <TextField
          {...defaultInputProps}
          label="designation"
          type="text"
          disabled
          sx={{
            marginTop: '14px',
            '& .MuiOutlinedInput-root': {
              fontWeight: '600'
            }
          }}
          required
          InputLabelProps={{ shrink: true }}
          name="designation"
          value={filterData.designation ? filterData.designation : ''}
        />
      </Grid>
      <Grid item lg={3} xs={12}>
        <TextMask
          label="Cnic"
          tabIndex={0}
          type="text"
          mask="99999-9999999-9"
          style={{ marginTop: '14px' }}
          required={true}
          name="cnic"
          disabled={true}
          shrink={true}
          value={filterData.cnic ? filterData.cnic : ''}
          onChange={handleInputChange}
        />

        <TextField
          {...defaultInputProps}
          label="Father Name"
          disabled
          type="text"
          style={{ marginTop: '14px' }}
          required
          InputLabelProps={{ shrink: true }}
          name="father_name"
          value={filterData.father_name ? filterData.father_name : ''}
        />

        <TextField
          {...defaultInputProps}
          label="contact"
          type="text"
          disabled
          style={{ marginTop: '14px' }}
          required
          name="contact"
          InputLabelProps={{ shrink: true }}
          value={filterData.contact ? filterData.contact : ''}
        />
      </Grid>
      <Grid item lg={2} xs={12}>
        <TextField
          {...defaultInputProps}
          label="month"
          type="month"
          disabled
          sx={{
            marginTop: '14px',
            '& .MuiOutlinedInput-root': {
              fontWeight: '600'
            }
          }}
          required
          InputLabelProps={{ shrink: true }}
          name="month"
          value={maxMonth}
          //
        />

        <TextField
          {...defaultInputProps}
          label="Domicile"
          type="text"
          disabled
          style={{ marginTop: '14px' }}
          required
          InputLabelProps={{ shrink: true }}
          name="domicile"
          value={filterData.domicile ? filterData.domicile : ''}
        />

        <TextField
          {...defaultInputProps}
          label="valid_upto"
          type="date"
          disabled
          sx={{
            marginTop: '14px',
            '& .MuiOutlinedInput-root': {
              fontWeight: '600'
            }
          }}
          required
          InputLabelProps={{ shrink: true }}
          name="valid_upto"
          value={filterData.valid_upto ? filterData.valid_upto : ''}
        />
      </Grid>
    </Grid>
  );
};

SearchSection.propTypes = {
  filterData: PropTypes.any,
  isFetching: PropTypes.bool,
  fetchEmployeePayroll: PropTypes.func
};

SearchSection.defaultProps = {
  filterData: {}
};

export default SearchSection;
