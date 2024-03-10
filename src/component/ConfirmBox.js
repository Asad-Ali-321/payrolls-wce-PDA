import * as React from 'react';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import Slide from '@mui/material/Slide';
import DeleteSweepIcon from '@mui/icons-material/DeleteSweep';
import PropTypes from 'prop-types';
import { Stack } from '@mui/material';

const Transition = React.forwardRef(function Transition(props, ref) {
  return <Slide direction="down" ref={ref} {...props} />;
});

export default function ConfirmBox(props) {
  const [open, setOpen] = React.useState(props.open);

  React.useEffect(() => {
    setOpen(props.open);
  }, [props.open]);

  const handleClose = () => {
    setOpen(false);
  };

  return (
    <>
      {/* <Button variant="outlined" onClick={handleClickOpen}>
        Slide in alert dialog
      </Button> */}
      <Dialog
        open={open}
        TransitionComponent={Transition}
        keepMounted
        onClose={handleClose}
        aria-describedby="alert-dialog-slide-description"
      >
        <DialogTitle variant="h3">{'Driver App Confirm'}</DialogTitle>
        <DialogContent style={{ textAlign: 'center' }}>
          <DeleteSweepIcon color="error" style={{ fontSize: '5rem' }} />
          <DialogContentText id="alert-dialog-slide-description">Are you sure to delete</DialogContentText>
        </DialogContent>
        <DialogActions>
          <Stack direction="row" spacing={2} justifyContent="space-between" width="100%">
            <Button onClick={props.onDisAgree} color="primary">
              Disagree
            </Button>
            <Button onClick={props.onAgree} color="error">
              Agree
            </Button>
          </Stack>
        </DialogActions>
      </Dialog>
    </>
  );
}

ConfirmBox.propTypes = {
  open: PropTypes.bool.isRequired,
  onAgree: PropTypes.func.isRequired,
  onDisAgree: PropTypes.func.isRequired
};
