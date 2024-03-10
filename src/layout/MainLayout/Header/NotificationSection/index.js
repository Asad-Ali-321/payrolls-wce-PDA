import React from 'react';

// material-ui
import { useTheme } from '@mui/material/styles';
import {
  Button,
  ClickAwayListener,
  Fade,
  Grid,
  Paper,
  Popper,
  Avatar,
  List,
  ListItemAvatar,
  ListItemText,
  ListItemSecondaryAction,
  Typography,
  ListItemButton,
  Badge
} from '@mui/material';

// third party
import PerfectScrollbar from 'react-perfect-scrollbar';

import NotificationsNoneTwoToneIcon from '@mui/icons-material/NotificationsNoneTwoTone';

// ==============================|| NOTIFICATION ||============================== //

const NotificationSection = () => {
  const theme = useTheme();
  const [open, setOpen] = React.useState(false);
  const anchorRef = React.useRef(null);

  const handleToggle = () => {
    setOpen((prevOpen) => !prevOpen);
  };

  const handleClose = (event) => {
    if (anchorRef.current && anchorRef.current.contains(event.target)) {
      return;
    }
    setOpen(false);
  };

  const prevOpen = React.useRef(open);
  React.useEffect(() => {
    if (prevOpen.current === true && open === false) {
      anchorRef.current.focus();
    }
    prevOpen.current = open;
  }, [open]);

  return (
    <>
      <Button
        sx={{
          minWidth: { sm: 50, xs: 35 }
        }}
        ref={anchorRef}
        aria-controls={open ? 'menu-list-grow' : undefined}
        aria-haspopup="true"
        aria-label="Notification"
        onClick={handleToggle}
        color="inherit"
      >
        <Badge color="warning">
          <NotificationsNoneTwoToneIcon sx={{ fontSize: '1.5rem' }} /> {}
        </Badge>
      </Button>
      <Popper
        placement="bottom-end"
        open={open}
        anchorEl={anchorRef.current}
        role={undefined}
        transition
        disablePortal
        modifiers={[
          {
            name: 'offset',
            options: {
              offset: [0, 10]
            }
          },
          {
            name: 'preventOverflow',
            options: {
              altAxis: true // false by default
            }
          }
        ]}
      >
        {({ TransitionProps }) => (
          <Fade {...TransitionProps}>
            <Paper>
              <ClickAwayListener onClickAway={handleClose}>
                <List
                  sx={{
                    width: '100%',
                    maxWidth: 350,
                    minWidth: 250,
                    backgroundColor: theme.palette.background.paper,
                    pb: 0,
                    borderRadius: '10px'
                  }}
                >
                  <PerfectScrollbar style={{ height: 'auto', overflowX: 'hidden' }}>
                    <ListItemButton alignItemsFlexStart sx={{ pt: 0 }}>
                      <ListItemAvatar>
                        <Avatar alt="Drivers" />
                      </ListItemAvatar>
                      <ListItemText
                        primary={<Typography variant="subtitle1">Driver</Typography>}
                        secondary={<Typography variant="subtitle2">Pending reviews</Typography>}
                      />
                      <ListItemSecondaryAction sx={{ top: 22 }}>
                        <Grid container justifyContent="flex-end">
                          <Grid item>
                            <Typography variant="caption" display="block" gutterBottom sx={{ color: theme.palette.grey[400] }}>
                              {pendingReviews}
                            </Typography>
                          </Grid>
                        </Grid>
                      </ListItemSecondaryAction>
                    </ListItemButton>
                  </PerfectScrollbar>
                </List>
              </ClickAwayListener>
            </Paper>
          </Fade>
        )}
      </Popper>
    </>
  );
};

export default NotificationSection;
