import { TextField } from '@mui/material';
import PropTypes from 'prop-types';
import InputMask from 'react-input-mask';
import { defaultInputProps } from './config';
const TextMask = (props) => {
  const { type, style, mask, name, value, onChange, required, label, placeholder, tabIndex, shrink, disabled } = props;
  return (
    <InputMask type={type} disabled={disabled} tabIndex={tabIndex} mask={mask} name={name} onChange={onChange} value={value}>
      {() => (
        <TextField
          disabled={disabled}
          required={required}
          InputLabelProps={{ shrink: shrink }}
          name={name}
          style={style}
          {...defaultInputProps}
          placeholder={placeholder}
          label={label}
        />
      )}
    </InputMask>
  );
};

TextMask.propTypes = {
  type: PropTypes.string,
  style: PropTypes.any,
  mask: PropTypes.string,
  name: PropTypes.string,
  required: PropTypes.bool,
  disabled: PropTypes.bool,
  shrink: PropTypes.bool,
  value: PropTypes.string,
  onChange: PropTypes.func,
  label: PropTypes.string,
  tabIndex: PropTypes.number
};

export default TextMask;
