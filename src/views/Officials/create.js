import * as React from 'react';
import Box from '@mui/material/Box';
import Modal from '@mui/material/Modal';
import PropTypes from 'prop-types';
import { Alert, Button, CircularProgress, Grid, Stack, TextField, useTheme } from '@mui/material';
import { clientStatus, defaultInputProps } from 'component/config';
import CloseIcon from '@mui/icons-material/Close';
import LibraryAddCheckIcon from '@mui/icons-material/LibraryAddCheck';
import { UploadFile } from 'component/uploadButton';
import { requestPost } from 'api/requestServer';

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
  const [userData, setUserData] = React.useState({ password: 123456, client_status: clientStatus[0] });
  const [alert, setAlert] = React.useState(false);
  const [alertMessage, setAlertMessage] = React.useState('');
  const [loading, setLoading] = React.useState(false);
  const [file, setFile] = React.useState(null);

  const handleInputChange = (event) => {
    const { name, value } = event.target;
    setUserData({ ...userData, [name]: value });
  };
  const handleSubmit = async (event) => {
    event.preventDefault();
    setLoading(true);
    ///default value for the senior
    const formData = new FormData();

    formData.append('is_client', userData.is_client || '');
    formData.append('first_name', userData.first_name || '');
    formData.append('last_name', userData.last_name || '');
    formData.append('phone', userData.phone || '');
    formData.append('email', userData.email || '');
    formData.append('country', userData.country || '');
    formData.append('state', userData.state || '');
    formData.append('city', userData.city || '');
    formData.append('location', userData.location || '');
    formData.append('address', userData.address || '');
    formData.append('client_status', userData.client_status || '');

    formData.append('firestore_id', firebaseDoc.id || '');

    if (file) formData.append('file', file, file.name);
    requestPost('users', formData).then((res) => {
      if (res.status) {
        onSuccess();
        setAlert(false);
        setUserData({});
      } else {
        setAlert(true);
        setAlertMessage(res.error ? res.error : 'Network Error');
      }
      setLoading(false);
    });
    console.log(userData);
  };

  return (
    <Modal open={open} aria-labelledby="modal-modal-title" aria-describedby="modal-modal-description">
      <Box sx={style}>
        <Button
          title="close modal"
          onClick={() => {
            onClose();
          }}
          variant="text"
          size="small"
          color="error"
          style={{ position: 'absolute', top: 10, right: 15 }}
        >
          <CloseIcon /> Close
        </Button>
        <form onSubmit={handleSubmit}>
          <div style={{ position: 'relative' }}>
            <b>Create new client</b>
          </div>
          <hr />
          <Grid container spacing={2}>
            <Grid item lg={6} xs={12} style={{ display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
              <UploadFile
                onFileChange={(target) => {
                  setFile(target);
                }}
              />
            </Grid>
            <Grid item lg={6} xs={12}>
              <TextField
                {...defaultInputProps}
                label="*First name"
                autoFocus
                type="text"
                required
                name="first_name"
                value={userData.first_name}
                onChange={handleInputChange}
              />
              <TextField
                {...defaultInputProps}
                label="*Last name"
                type="text"
                style={{ marginTop: '14px' }}
                required
                name="last_name"
                value={userData.last_name}
                onChange={handleInputChange}
              />
              <TextField
                {...defaultInputProps}
                label="*Phone"
                type="number"
                style={{ marginTop: '14px' }}
                required
                name="phone"
                value={userData.phone}
                onChange={handleInputChange}
              />
            </Grid>
          </Grid>
          <Box mt={5}>
            <hr />
            {alert ? <Alert severity="error">{alertMessage}</Alert> : ''}
            <Stack direction={'row'} justifyContent="space-between" mt={1}>
              <Button
                title="create"
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
      </Box>
    </Modal>
  );
};

Create.propTypes = {
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  onSuccess: PropTypes.func.isRequired
};

export default Create;
