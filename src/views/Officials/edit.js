import * as React from 'react';
import Box from '@mui/material/Box';
import Modal from '@mui/material/Modal';
import PropTypes from 'prop-types';
import { Button, CircularProgress, Grid, Stack, TextField, useTheme } from '@mui/material';
import { defaultInputProps } from 'component/config';
import CloseIcon from '@mui/icons-material/Close';
import LibraryAddCheckIcon from '@mui/icons-material/LibraryAddCheck';
import { UploadFile } from 'component/uploadButton';
import { requestPost } from 'api/requestServer';
import { getOne } from 'api/official';
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

const Edit = (props) => {
  const { open, onClose, onSuccess, _id } = props;
  const theme = useTheme();
  const [userData, setUserData] = React.useState({});
  const [loading, setLoading] = React.useState(false);

  const handleInputChange = (event) => {
    const { name, value } = event.target;
    setUserData({ ...userData, [name]: value });
  };

  React.useEffect(() => {
    getData();
  }, [props._id]);

  const getData = async () => {
    if (props._id && props._id != 0)
      await getOne(_id).then((res) => {
        setUserData(res);
      });
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    setLoading(true);

    requestPost('officials/update', userData).then(() => {
      onSuccess();
      toast.success('updated');
      setUserData({});
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
            <b>Edit official details</b>
          </div>
          <hr />
          <Grid container spacing={2}>
            <Grid item lg={6} xs={12} style={{ display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
              <UploadFile
                onFileChange={() => {
                  // setFile(target);
                }}
              />
            </Grid>
            <Grid item lg={6} xs={12}>
              <TextField
                {...defaultInputProps}
                label="*File#"
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
                label="*Official Name"
                autoFocus
                type="text"
                style={{ marginTop: '14px' }}
                required
                name="official_name"
                value={userData.official_name}
                onChange={handleInputChange}
              />
              <TextField
                {...defaultInputProps}
                label="*Father Name"
                type="text"
                style={{ marginTop: '14px' }}
                required
                name="father_name"
                value={userData.father_name}
                onChange={handleInputChange}
              />
            </Grid>
            <Grid item lg={6} xs={12}>
              <TextField
                {...defaultInputProps}
                label="*Cnic"
                autoFocus
                type="text"
                required
                name="cnic"
                value={userData.cnic}
                onChange={handleInputChange}
              />
            </Grid>

            <Grid item lg={6} xs={12}>
              <TextField
                {...defaultInputProps}
                label="*Designation"
                type="text"
                style={{ marginTop: '14px' }}
                required
                name="designation"
                value={userData.designation}
                onChange={handleInputChange}
              />
            </Grid>

            <Grid item lg={6} xs={12}>
              <TextField
                {...defaultInputProps}
                label="*Chargeable Head"
                autoFocus
                type="text"
                required
                name="chargeable_head"
                value={userData.chargeable_head}
                onChange={handleInputChange}
              />
            </Grid>

            <Grid item lg={6} xs={12}>
              <TextField
                {...defaultInputProps}
                label="*Monthly Pay"
                autoFocus
                type="text"
                required
                name="monthly_pay"
                value={userData.monthly_pay}
                onChange={handleInputChange}
              />
            </Grid>

            <Grid item lg={12} xs={12}>
              <TextField
                {...defaultInputProps}
                label="*Directorate"
                autoFocus
                type="text"
                required
                name="directorate"
                value={userData.directorate}
                onChange={handleInputChange}
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
                style={{ width: '30%', background: theme.palette.primary.light }}
                size="medium"
              >
                {loading ? <CircularProgress /> : <LibraryAddCheckIcon />} Update
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

Edit.propTypes = {
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  onSuccess: PropTypes.func.isRequired,
  _id: PropTypes.number
};

export default Edit;
