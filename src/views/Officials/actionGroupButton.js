import MenuItem from '@mui/material/MenuItem';
import PropTypes from 'prop-types';
import * as React from 'react';
import Button from '@mui/material/Button';
import Menu from '@mui/material/Menu';
import EditIcon from '@mui/icons-material/Edit';
import Fade from '@mui/material/Fade';
import MoreVertIcon from '@mui/icons-material/MoreVert';
import RemoveIcon from '@mui/icons-material/Remove';
const ActionGroupButton = (props) => {
  const [anchorEl, setAnchorEl] = React.useState(null);
  debugger
  const open = Boolean(anchorEl);
  const handleClick = (event) => {
    setAnchorEl(event.currentTarget);
  };
  const handleClose = () => {
    setAnchorEl(null);
  };
  return (
    <div>
      <Button
        id="fade-button"
        aria-controls={open ? 'fade-menu' : undefined}
        aria-haspopup="true"
        aria-expanded={open ? 'true' : undefined}
        onClick={handleClick}
      >
        <MoreVertIcon />
        Options
      </Button>
      <Menu
        id="fade-menu"
        MenuListProps={{
          'aria-labelledby': 'fade-button'
        }}
        anchorEl={anchorEl}
        open={open}
        onClose={handleClose}
        TransitionComponent={Fade}
      >
        <MenuItem
          key={1}
          onClick={() => {
            props.onEdit(props.row.id);
            handleClose();
          }}
        >
          <EditIcon className="action-icons-font-size" /> edit
        </MenuItem>
        <MenuItem
          key={2}
          onClick={() => {
            props.onDelete(props.row.id);
            handleClose();
          }}
        >
          <RemoveIcon className="action-icons-font-size" /> delete
        </MenuItem>
      </Menu>
    </div>
  );
};

ActionGroupButton.propTypes = {
  row: PropTypes.any,
  onEdit: PropTypes.func,
  onDelete: PropTypes.func
};
export default ActionGroupButton;
