import { Autocomplete, TextField } from '@mui/material';
import { defaultInputProps } from './config';
import PropTypes from 'prop-types';

const LookUpComponent = (props) => {
  const { labelIndex, valueIndex } = props;
  return (
    <Autocomplete
      disablePortal
      id="combo-box-demo"
      options={props.items}
      value={props.items.find((option) => option[labelIndex] === props.defaultValue)}
      onChange={(event, newInputValue) => {
        if (newInputValue) props.onChange({ target: { name: props.name, value: newInputValue[valueIndex] } });
      }}
      getOptionLabel={(option) => option[labelIndex]} // Use props.labelIndex to access the correct property
      getOptionKey={(option) => option[valueIndex]} // Use props.valueIndex to access the correct property
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
        <li {...props} key={option[valueIndex]}>
          {option[labelIndex]}
        </li> // Use props.labelIndex and props.valueIndex to access the correct properties
      )}
    />
  );
};

LookUpComponent.propTypes = {
  name: PropTypes.string,
  label: PropTypes.string,
  size: PropTypes.string,
  variant: PropTypes.string,
  onChange: PropTypes.func,
  items: PropTypes.array,
  defaultValue: PropTypes.any,

  labelIndex: PropTypes.string,
  valueIndex: PropTypes.string
};

export default LookUpComponent;
