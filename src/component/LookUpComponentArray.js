import { Autocomplete, TextField } from '@mui/material';
import { defaultInputProps } from './config';
import PropTypes from 'prop-types';

const LookUpComponentArray = (props) => {
  return (
    <Autocomplete
      disablePortal
      id="combo-box-demo"
      options={props.items}
      value={props.items.find((option) => option === props.defaultValue)}
      style={props.style}
      onChange={(event, newInputValue) => {
        if (newInputValue) props.onChange({ target: { name: props.name, value: newInputValue } });
      }}
      renderInput={(params) => (
        <TextField
          {...params}
          required
          name={props.name}
          size={props.size}
          variant={props.variant}
          label={props.label}
          {...defaultInputProps}
        />
      )}
      renderOption={(props, option) => (
        <li {...props} key={option}>
          {option}
        </li> // Use props.labelIndex and props.valueIndex to access the correct properties
      )}
    />
  );
};

LookUpComponentArray.propTypes = {
  name: PropTypes.string,
  label: PropTypes.string,
  size: PropTypes.string,
  variant: PropTypes.string,
  onChange: PropTypes.func,
  items: PropTypes.array,
  defaultValue: PropTypes.any,
  style: PropTypes.any
};

export default LookUpComponentArray;
