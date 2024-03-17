import * as React from 'react';
import Box from '@mui/material/Box';
import Modal from '@mui/material/Modal';
import PropTypes from 'prop-types';
import { Button, CircularProgress, Grid, Stack, TextField, Typography, useTheme } from '@mui/material';
import { defaultInputProps } from 'component/config';
import CloseIcon from '@mui/icons-material/Close';
import LibraryAddCheckIcon from '@mui/icons-material/LibraryAddCheck';
import { requestPost } from 'api/requestServer';
import { toast } from 'react-toastify';

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

    requestPost('directorates/create', userData).then(async (res) => {
      if (res.code != 0) toast.warning(res.message);
      else {
        onSuccess();
        toast.success('created');
        setUserData({});
      }
      setLoading(false);
    });
  };

  return (
    <Modal open={open} aria-labelledby="modal-modal-title" aria-describedby="modal-modal-description">
      <Box sx={style}>
        <form onSubmit={handleSubmit}>
          <Grid container spacing={2}>
            <Grid
              item
              lg={4}
              xs={12}
              style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', textAlign: 'center' }}
            >
              <Typography variant="h6" color={'primary'}>
                CREATE NEW DIRECTORATE
              </Typography>
            </Grid>
            <Grid item lg={8} xs={12}>
              <TextField
                {...defaultInputProps}
                label="Directorate Title"
                autoFocus
                type="text"
                required
                style={{ marginTop: '14px' }}
                name="title"
                value={userData.title}
                onChange={handleInputChange}
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
