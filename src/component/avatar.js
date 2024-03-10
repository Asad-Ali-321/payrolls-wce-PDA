import * as React from 'react';
import { styled } from '@mui/material/styles';
import Badge from '@mui/material/Badge';
import Avatar from '@mui/material/Avatar';
import PropTypes from 'prop-types';
import { Box } from '@mui/material';
const StyledBadge = styled(Badge)(({ theme }) => ({
  cursor: 'pointer',
  '& .MuiBadge-badge': {
    backgroundColor: '#44b700',
    color: '#44b700',
    boxShadow: `0 0 0 2px ${theme.palette.background.paper}`,
    '&::after': {
      position: 'absolute',
      top: 0,
      left: 0,
      width: '100%',
      height: '100%',
      borderRadius: '50%',
      animation: 'ripple 1.2s infinite ease-in-out',
      border: '1px solid currentColor',
      content: '""'
    }
  },
  '@keyframes ripple': {
    '0%': {
      transform: 'scale(.8)',
      opacity: 1
    },
    '100%': {
      transform: 'scale(2.4)',
      opacity: 0
    }
  }
}));

const StyledBox = styled(Box)`
  cursor: pointer;
`;
const small = {
  width: 32,
  height: 32
};
const large = {
  width: 60,
  height: 60
};

const SnapAvatar = (props) => {
  return props.isOnline ? (
    <StyledBox>
      <StyledBadge overlap="circular" anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }} variant="dot">
        <Avatar
          sx={props.size == 'small' ? small : props.size == 'large' ? large : ''}
          onClick={props.onClick}
          alt={props.alt}
          src={process.env.REACT_APP_PUBLIC_URL + props.snap}
        />
      </StyledBadge>
    </StyledBox>
  ) : (
    <StyledBox>
      <Avatar
        sx={props.size == 'small' ? small : props.size == 'large' ? large : ''}
        onClick={props.onClick}
        alt={props.alt}
        src={process.env.REACT_APP_PUBLIC_URL + props.snap}
      />
    </StyledBox>
  );
};

SnapAvatar.propTypes = {
  snap: PropTypes.string,
  alt: PropTypes.string,
  size: PropTypes.string,
  onClick: PropTypes.func,
  isOnline: PropTypes.bool
};

export default SnapAvatar;
