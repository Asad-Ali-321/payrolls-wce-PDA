import { Box, Button, Typography } from '@mui/material';
import PropTypes from 'prop-types';
import {
  MRT_GlobalFilterTextField,
  MRT_ShowHideColumnsButton,
  MRT_ToggleDensePaddingButton,
  MRT_ToggleFiltersButton
} from 'material-react-table';
import DownloadIcon from '@mui/icons-material/Download';
import { CSVLink } from 'react-csv';

const TableHeader = (props) => {
  const { table, data } = props;

  return (
    <>
      <Box display="flex" style={{ margin: '0.5rem 1.5rem' }} justifyContent="space-between" alignItems="center">
        <div display="flex">
          <Typography variant='h5'>Officials List</Typography>
        </div>
        <div display="flex">
          <MRT_GlobalFilterTextField style={{ float: 'right', textAlign: 'center', marginLeft: '0.5rem' }} table={table} />
        </div>
        <div>
          <Button startIcon={<DownloadIcon />}>
            <CSVLink
              data={data}
              style={{ textDecoration: 'none', cursor: 'pointer' }}
              filename={'pay_roll_system_generated.csv'}
              title="export payroll"
            >
              Export
            </CSVLink>
          </Button>

          <MRT_ToggleDensePaddingButton table={table} />
          <MRT_ToggleFiltersButton table={table} />
          <MRT_ShowHideColumnsButton table={table} />
        </div>
      </Box>
    </>
  );
};

TableHeader.propTypes = {
  table: PropTypes.any,
  data: PropTypes.any
};

export default TableHeader;
