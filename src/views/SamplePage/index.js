import React from 'react';

// material-ui
import { Card, CardHeader, CardContent, Divider, Grid, Typography } from '@mui/material';

// project import
import { gridSpacing } from 'config.js';

// ==============================|| SAMPLE PAGE ||============================== //

const SamplePage = () => {
  return (
    <Grid container spacing={gridSpacing}>
      <Grid item>
        <Card>
          <CardHeader
            title={
              <Typography component="div" className="card-header">
                Sample Page
              </Typography>
            }
          />
          <Divider />
          <CardContent>
            <Typography variant="body2">
              Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut
              enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor
              in reprehenderit in voluptate velit esse cillum dolore eu fugiatnulla pariatur. Excepteur sint occaecat cupidatat non
              proident, sunt in culpa qui officia deserunt mollitanim id est laborum.
            </Typography>
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );
};

export default SamplePage;
