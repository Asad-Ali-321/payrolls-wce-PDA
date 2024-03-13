import * as React from 'react';
import Box from '@mui/material/Box';
import Modal from '@mui/material/Modal';
import PropTypes from 'prop-types';
import { Button, CircularProgress, Grid, Stack, TextField, useTheme } from '@mui/material';
import { defaultInputProps, userRole, userStatuses } from 'component/config';
import CloseIcon from '@mui/icons-material/Close';
import LibraryAddCheckIcon from '@mui/icons-material/LibraryAddCheck';
import { requestPost } from 'api/requestServer';
import { toast } from 'react-toastify';
import SelectComponent from 'component/SelectComponent';

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
  const [loading, setLoading] = React.useState(false);

  const handleInputChange = (event) => {
    const { name, value } = event.target;
    setUserData({ ...userData, [name]: value });
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    setLoading(true);

    requestPost('users/create', userData).then((res) => {
      if (res.code == 0) {
        onSuccess();
        toast.success('created');
        setUserData({});
      } else toast.error(res.message);
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
            <b>Create official details</b>
          </div>
          <hr />
          <Grid container spacing={2}>
            <Grid item lg={6} xs={12}>
              <TextField
                {...defaultInputProps}
                label="*Cnic"
                autoFocus
                type="text"
                required
                name="user_name"
                value={userData.user_name}
                onChange={handleInputChange}
              />
            </Grid>

            <Grid item lg={6} xs={12}>
              <TextField
                {...defaultInputProps}
                label="*email"
                Focus
                type="text"
                required
                name="email"
                value={userData.email}
                onChange={handleInputChange}
              />
            </Grid>

            <Grid item lg={6} xs={12}>
              <TextField
                {...defaultInputProps}
                label="*password"
                Focus
                type="text"
                required
                name="password"
                value={userData.password}
                onChange={handleInputChange}
              />
            </Grid>

            <Grid item lg={6} xs={12}>
              <SelectComponent name="role" label="*Role" onChange={handleInputChange} value={userData.role} items={userRole} />
            </Grid>

            <Grid item lg={6} xs={12}>
              <SelectComponent name="status" label="*Status" onChange={handleInputChange} value={userData.status} items={userStatuses} />
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
