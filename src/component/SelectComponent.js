import * as React from 'react';
import PropTypes from 'prop-types';
import { FormControl, InputLabel, MenuItem, Select } from '@mui/material';
import { defaultInputProps } from './config';
const SelectComponent = (props) => {
  return (
    <FormControl fullWidth>
      <InputLabel>{props.label}</InputLabel>
      <Select
        {...defaultInputProps}
        value={props.value ? props.value : props.items[0]}
        defaultValue={props.defaultValue}
        name={props.name}
        label={props.label}
        onChange={props.onChange}
        size={props.size}
        variant={props.variant}
      >
        {props.items
          ? props.items.map((item) => (
              <MenuItem key={item} value={item}>
                {item}
              </MenuItem>
            ))
          : ''}
      </Select>
    </FormControl>
  );
};

// default value undefined use [0] as default value
SelectComponent.propTypes = {
  name: PropTypes.string,
  value: PropTypes.string,
  label: PropTypes.string,
  size: PropTypes.string,
  variant: PropTypes.string,
  onChange: PropTypes.func,
  items: PropTypes.array,
  defaultValue: PropTypes.string
};

export default SelectComponent;
