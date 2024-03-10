import * as React from 'react';
import Typography from '@mui/material/Typography';
import PropTypes from 'prop-types';
import { Button, CardHeader } from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
const PageHeader = (props) => {
  return (
    <CardHeader
      style={{ background: props.bgColor }}
      title={
        <div style={{ position: 'relative' }}>
          <Typography variant="h1" color={props.color} className="card-header">
            {props.title}
          </Typography>
          <Typography variant="h1" color={props.color} className="card-sub-header">
            {props.subheader}
          </Typography>
          {props.onCreate ? (
            <Button
              title="create"
              onClick={props.onCreate}
              variant="contained"
              size="small"
              style={{ position: 'absolute', top: 0, right: 0 }}
            >
              <AddIcon /> Create
            </Button>
          ) : (
            ''
          )}
        </div>
      }
    />
  );
};

PageHeader.propTypes = {
  title: PropTypes.string,
  bgColor: PropTypes.string,
  color: PropTypes.string,
  subheader: PropTypes.any,
  onCreate: PropTypes.func
};

export default PageHeader;



