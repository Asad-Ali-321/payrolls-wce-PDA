import React, { useEffect, useRef, useState } from 'react';
import PropTypes from 'prop-types';
import Button from '@mui/material/Button';
import styled from '@emotion/styled';
import { Card } from '@mui/material';

const StyledButton = styled(Button)`
  position: absolute;
  bottom: 10px; /* Adjust this value as needed */
  left: 50%; /* Align the button horizontally */
  transform: translateX(-50%); /* Center the button horizontally */
`;
const StyledContainer = styled(Card)`
  position: relative;
  padding: 20px;
  border-radius: 20px;
  width: 100%;
  height: 150px;
  background-size: 100% 100%; // Cover the entire container
  background-repeat: no-repeat;
  background-image: url(${(props) => props.image});

  @media (min-width: 500px) {
    width: 50%;
  }
`;

export const UploadFile = (props) => {
  const { label, variant, disabled, style, size, startIcon, endIcon, borderRadius, color, title, onFileChange, defaultImage, returnType } =
    props;

  const [image, setImage] = useState(defaultImage);
  const inputRef = useRef(null);
  useEffect(() => {
    setImage(defaultImage);
  }, [defaultImage]);

  const handleFileInputChange = (event) => {
    const file = event.target.files[0];
    const reader = new FileReader();
    reader.onloadend = () => {
      setImage(reader.result);
      if (returnType == 'base64') onFileChange(reader.result);
      else onFileChange(file);
    };
    if (file) {
      reader.readAsDataURL(file);
    }
  };

  return (
    <StyledContainer image={image}>
      <input
        type="file"
        ref={inputRef}
        hidden
        onChange={handleFileInputChange} // Add onChange event to prevent React warning
      />
      {!disabled ? (
        <StyledButton
          variant={variant}
          style={{
            ...style,
            textTransform: 'none',
            borderRadius: borderRadius,
            width: '90%'
          }}
          disabled={disabled}
          color={color}
          size={size}
          startIcon={startIcon ? startIcon : ''}
          endIcon={endIcon}
          title={title}
          onClick={() => {
            inputRef.current.click();
          }}
        >
          {label}
        </StyledButton>
      ) : (
        ''
      )}
    </StyledContainer>
  );
};

UploadFile.propTypes = {
  label: PropTypes.string,
  variant: PropTypes.oneOf(['text', 'contained', 'outlined']),
  disabled: PropTypes.bool,
  style: PropTypes.object,
  size: PropTypes.oneOf(['small', 'medium', 'large']),
  borderRadius: PropTypes.string,
  color: PropTypes.string,
  title: PropTypes.string,
  defaultImage: PropTypes.string,
  onFileChange: PropTypes.func,
  returnType: PropTypes.oneOf(['base64', 'file'])
};
UploadFile.defaultProps = {
  label: 'Upload',
  variant: 'contained',
  size: 'small',
  defaultImage: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png'
};
