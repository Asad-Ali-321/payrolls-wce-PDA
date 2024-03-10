import * as React from 'react';
import Box from '@mui/material/Box';
import Modal from '@mui/material/Modal';
import PropTypes from 'prop-types';
import { Button, Grid, Stack } from '@mui/material';
import CloseIcon from '@mui/icons-material/Close';
import GetAppIcon from '@mui/icons-material/GetApp';
import { saveAs } from 'file-saver';
const style = {
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  width: '30%',
  '@media (max-width: 768px)': {
    width: '100%' // Adjust width for smaller screens
  },
  bgcolor: 'background.paper',
  boxShadow: 24,
  p: 4
};

const SnapBox = (props) => {
  const { open, onClose, snap } = props;
  const Snap = process.env.REACT_APP_PUBLIC_URL + snap;
  return (
    <Modal open={open} aria-labelledby="modal-modal-title" aria-describedby="modal-modal-description">
      <Box sx={style}>
        <Grid container spacing={2}>
          <Grid item lg={12} xs={12} style={{ display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
            <img style={{ maxWidth: '30vh', maxHeight: '100%', height: 'auto', width: 'auto' }} src={Snap} alt="snap not found" />
          </Grid>
          <Grid item lg={12} xs={12} style={{ display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
            <Button
              variant="text"
              size="small"
              title="download snap"
              onClick={() => {
                snap ? saveAs(Snap, Snap.split('/')[Snap.split('/').length - 1]) : '';
              }}
            >
              <GetAppIcon /> download
            </Button>
          </Grid>
        </Grid>

        <Box mt={1}>
          <hr />
          <Stack direction={'row'} justifyContent="space-between" mt={1}>
            <Button
              title="close modal"
              onClick={() => {
                onClose();
              }}
              variant="outlined"
              color="error"
              fullWidth={true}
              size="medium"
            >
              <CloseIcon /> Close
            </Button>
          </Stack>
        </Box>
      </Box>
    </Modal>
  );
};

SnapBox.propTypes = {
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  snap: PropTypes.string.isRequired
};

export default SnapBox;
