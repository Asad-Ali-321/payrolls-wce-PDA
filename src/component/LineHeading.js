import { Divider, Grid, Typography } from '@mui/material';
import * as React from 'react';
import PropTypes from 'prop-types';
const LineHeading = (props) => {
  const { heading, color } = props;
  return (
    <Grid container alignItems="center" spacing={1} item lg={12} xs={12}>
      <Grid item>
        <Typography variant="h6" color={color}>
          {heading}
        </Typography>
      </Grid>
      <Grid item xs>
        <Divider />
      </Grid>
    </Grid>
  );
};

LineHeading.propTypes = {
  heading: PropTypes.any,
  color: PropTypes.any
};

export default LineHeading;
