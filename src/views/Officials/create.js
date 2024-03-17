import * as React from 'react';
import Box from '@mui/material/Box';
import Modal from '@mui/material/Modal';
import PropTypes from 'prop-types';
import {
  Button,
  CircularProgress,
  Divider,
  FormControlLabel,
  Grid,
  LinearProgress,
  Stack,
  TextField,
  Typography,
  useTheme
} from '@mui/material';
import { Banks, defaultInputProps, districts } from 'component/config';
import CloseIcon from '@mui/icons-material/Close';
import LibraryAddCheckIcon from '@mui/icons-material/LibraryAddCheck';
import { UploadFile } from 'component/uploadButton';
import { requestGet, requestPost } from 'api/requestServer';
import { toast } from 'react-toastify';
import Checkbox from '@mui/material/Checkbox';
import LookUpComponent from 'component/LookUpComponent';
import LookUpComponentArray from 'component/LookUpComponentArray';
import TextMask from 'component/TextMask';

const style = {
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  width: '60%',
  '@media (max-width: 768px)': {
    width: '100%' // Adjust width for smaller screens
  },
  bgcolor: 'background.paper',
  boxShadow: 24,
  p: 4
};

const Create = (props) => {
  const { open, onClose, onSuccess } = props;
  const theme = useTheme();
  const [userData, setUserData] = React.useState({});
  const [bankData, setBankData] = React.useState({});
  const [loading, setLoading] = React.useState(false);
  const [isFetching, setIsFetching] = React.useState(false);
  const [directorates, setDirectorates] = React.useState([]);
  const [designations, setDesignations] = React.useState([]);
  const [chargeable_heads, setChargeableHeads] = React.useState([]);

  const handleInputChange = (event) => {
    const { name, value } = event.target;
    setUserData({ ...userData, [name]: value });
  };

  const handleBankInputChange = (event) => {
    const { name, value } = event.target;
    setBankData({ ...bankData, [name]: value });
  };

  React.useEffect(() => {
    getData();
  }, []);

  const getData = async () => {
    setIsFetching(true);

    await requestGet('chargeableHeads').then((result) => {
      setDirectorates(result);
    });
    await requestGet('designations').then((result) => {
      setDesignations(result);
    });
    await requestGet('directorates').then((result) => {
      setChargeableHeads(result);
    });

    setIsFetching(false);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    setLoading(true);

    requestPost('officials/create', userData).then(async (res) => {
      if (res.id == 0) toast.warning(res.status.message);
      else {
        bankData.official_id = res.id;
        await requestPost('officials/create_banks', bankData).then(async () => {
          onSuccess();
          toast.success('created');
          setUserData({});
          setBankData({});
        });
      }
      setLoading(false);
    });
  };

  return (
    <Modal open={open} aria-labelledby="modal-modal-title" aria-describedby="modal-modal-description">
      <Box sx={style}>
        {!isFetching ? (
          <form onSubmit={handleSubmit}>
            <Grid container spacing={2}>
              <Grid
                item
                lg={4}
                xs={12}
                style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', textAlign: 'center' }}
              >
                <Typography variant="h6" color={'primary'}>
                  CREATE NEW EMPLOYEE
                </Typography>
                <UploadFile
                  onFileChange={() => {
                    // setFile(target);
                  }}
                />
              </Grid>
              <Grid item lg={4} xs={12}>
                <TextField
                  {...defaultInputProps}
                  label="File#"
                  autoFocus
                  type="text"
                  required
                  style={{ marginTop: '14px' }}
                  name="file_no"
                  value={userData.file_no}
                  onChange={handleInputChange}
                />
                <TextField
                  {...defaultInputProps}
                  label="Employee Name"
                  type="text"
                  style={{ marginTop: '14px' }}
                  required
                  name="official_name"
                  value={userData.official_name}
                  onChange={handleInputChange}
                />
                <TextField
                  {...defaultInputProps}
                  label="Father Name"
                  type="text"
                  style={{ marginTop: '14px' }}
                  required
                  name="father_name"
                  value={userData.father_name}
                  onChange={handleInputChange}
                />
              </Grid>
              <Grid item lg={4} xs={12}>
                <TextMask
                  label="Cnic"
                  type="text"
                  mask="99999-9999999-9"
                  style={{ marginTop: '14px' }}
                  required={true}
                  name="cnic"
                  placeholder="99999-9999999-9"
                  value={userData.cnic}
                  onChange={handleInputChange}
                />

                <TextField
                  {...defaultInputProps}
                  label="date_of_birth"
                  type="date"
                  style={{ marginTop: '14px' }}
                  required
                  InputLabelProps={{ shrink: true }}
                  name="date_of_birth"
                  value={userData.date_of_birth}
                  onChange={handleInputChange}
                />

                <LookUpComponentArray
                  label="domicile"
                  type="text"
                  style={{ marginTop: '14px' }}
                  required
                  name="domicile"
                  defaultValue={userData.domicile}
                  onChange={handleInputChange}
                  items={districts}
                />
              </Grid>

              <Grid item lg={4} xs={12}>
                <TextField
                  {...defaultInputProps}
                  label="appointment_date"
                  type="date"
                  InputLabelProps={{ shrink: true }}
                  required
                  name="appointment_date"
                  value={userData.appointment_date}
                  onChange={handleInputChange}
                />
              </Grid>
              <Grid item lg={4} xs={12}>
                <TextField
                  {...defaultInputProps}
                  label="contact"
                  type="text"
                  InputLabelProps={{ shrink: true }}
                  required
                  name="contact"
                  value={userData.contact}
                  onChange={handleInputChange}
                />
              </Grid>

              <Grid item lg={4} xs={12}>
                <TextField
                  {...defaultInputProps}
                  label="valid_upto"
                  type="date"
                  InputLabelProps={{ shrink: true }}
                  disabled
                  value={userData.valid_upto}
                />
              </Grid>
              <Grid item lg={4} xs={12}>
                <LookUpComponent
                  label="designation"
                  type="text"
                  required
                  name="designation"
                  defaultValue={userData.designation}
                  onChange={handleInputChange}
                  labelIndex="title"
                  valueIndex="title"
                  items={designations}
                />
              </Grid>
              <Grid item lg={4} xs={12}>
                <LookUpComponent
                  label="directorate"
                  type="text"
                  required
                  name="directorate"
                  defaultValue={userData.directorate}
                  onChange={handleInputChange}
                  labelIndex="title"
                  valueIndex="title"
                  items={directorates}
                />
              </Grid>

              <Grid item lg={4} xs={12}>
                <TextField
                  {...defaultInputProps}
                  label="monthly_pay"
                  type="text"
                  required
                  name="monthly_pay"
                  value={userData.monthly_pay}
                  onChange={handleInputChange}
                />
              </Grid>
              <Grid item lg={4} xs={12}>
                <LookUpComponent
                  label="chargeable_head"
                  type="text"
                  required
                  name="chargeable_head"
                  defaultValue={userData.chargeable_head}
                  onChange={handleInputChange}
                  labelIndex="title"
                  valueIndex="title"
                  items={chargeable_heads}
                />
              </Grid>

              <Grid item lg={4} xs={12}>
                <FormControlLabel
                  control={<Checkbox defaultChecked={userData.income_tax_applied == 1 ? true : false} />}
                  name="income_tax_applied"
                  label="income tax"
                  onChange={(event) => {
                    const value = event.target.checked ? '1' : '0';
                    setUserData({ ...userData, income_tax_applied: value });
                  }}
                />
              </Grid>
              <Grid item lg={4} xs={12}>
                <FormControlLabel
                  control={<Checkbox defaultChecked={userData.is_salary_blocked == 1 ? true : false} />}
                  name="is_salary_blocked"
                  label="salary blocked"
                  onChange={(event) => {
                    const value = event.target.checked ? '1' : '0';
                    setUserData({ ...userData, is_salary_blocked: value });
                  }}
                />
              </Grid>

              <Grid item lg={12} xs={12}>
                <TextField
                  {...defaultInputProps}
                  label="address"
                  type="text"
                  required
                  name="address"
                  value={userData.address}
                  onChange={handleInputChange}
                />
              </Grid>

              <Grid container alignItems="center" spacing={1} item lg={12} xs={12}>
                <Grid item>
                  <Typography variant="h6" color={'primary'}>
                    Bank Details
                  </Typography>
                </Grid>
                <Grid item xs>
                  <Divider />
                </Grid>
              </Grid>
              <Grid item lg={6} xs={12}>
                <LookUpComponentArray
                  label="bank_name"
                  type="text"
                  required
                  name="bank_name"
                  defaultValue={bankData.bank_name}
                  onChange={handleBankInputChange}
                  items={Banks}
                />
              </Grid>
              <Grid item lg={6} xs={12}>
                <TextField
                  {...defaultInputProps}
                  label="branch_name"
                  type="text"
                  required
                  name="branch_name"
                  value={bankData.branch_name}
                  onChange={handleBankInputChange}
                />
              </Grid>
              <Grid item lg={6} xs={12}>
                <TextField
                  {...defaultInputProps}
                  label="branch_code"
                  type="number"
                  required
                  name="branch_code"
                  value={bankData.branch_code}
                  onChange={handleBankInputChange}
                />
              </Grid>
              <Grid item lg={6} xs={12}>
                <TextField
                  {...defaultInputProps}
                  label="account_number"
                  type="text"
                  required
                  name="account_number"
                  value={bankData.account_number}
                  onChange={handleBankInputChange}
                />
              </Grid>
            </Grid>
            <Box mt={5}>
              <hr />
              <Stack direction={'row'} justifyContent="space-between" mt={1}>
                <Button
                  title="Create"
                  disabled={loading}
                  variant="contained"
                  type="submit"
                  style={{ width: '30%', background: theme.palette.primary.light }}
                  size="medium"
                >
                  {loading ? <CircularProgress /> : <LibraryAddCheckIcon />} Create
                </Button>
                <Button
                  title="close modal"
                  onClick={() => {
                    onClose();
                  }}
                  variant="outlined"
                  color="error"
                  style={{ width: '30%' }}
                  size="medium"
                >
                  <CloseIcon /> Close
                </Button>
              </Stack>
            </Box>
          </form>
        ) : (
          <LinearProgress />
        )}
      </Box>
    </Modal>
  );
};

Create.propTypes = {
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  onSuccess: PropTypes.func.isRequired,
  _id: PropTypes.number
};

export default Create;
