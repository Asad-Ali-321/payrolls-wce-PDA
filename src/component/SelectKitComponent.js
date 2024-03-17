import * as React from 'react';
import PropTypes from 'prop-types';
import { FormControl, InputLabel, MenuItem, Select } from '@mui/material';
import { defaultInputProps } from './config';
const SelectKitComponent = (props) => {
  return (
    <FormControl fullWidth>
      <InputLabel>{props.label}</InputLabel>
      <Select
        {...defaultInputProps}
        defaultValue={props.defaultValue}
        name={props.name}
        label={props.label}
        onChange={props.onChange}
        size={props.size}
        variant={props.variant}
      >
        {props.items
          ? props.items.map((item, index) => (
              <MenuItem key={index} value={item[props.valueIndex]}>
                {item[props.labelIndex]}
              </MenuItem>
            ))
          : ''}
      </Select>
    </FormControl>
  );
};

SelectKitComponent.propTypes = {
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

export default SelectKitComponent;
