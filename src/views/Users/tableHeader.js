import { Box, Button, Typography } from '@mui/material';
import PropTypes from 'prop-types';
import AddIcon from '@mui/icons-material/Add';

import {
  MRT_GlobalFilterTextField,
  MRT_ShowHideColumnsButton,
  MRT_ToggleDensePaddingButton,
  MRT_ToggleFiltersButton
} from 'material-react-table';
import ExportCSV from 'component/ExportCSV';

const TableHeader = (props) => {
  const { table, data, onCreate } = props;

  return (
    <>
      <Box display="flex" style={{ margin: '0.5rem 1.5rem' }} justifyContent="space-between" alignItems="center">
        <div display="flex">
          <Typography variant="h5">Users List</Typography>
        </div>
        <div display="flex">
          <MRT_GlobalFilterTextField style={{ float: 'right', textAlign: 'center', marginLeft: '0.5rem' }} table={table} />
        </div>
        <div>
          <ExportCSV data={data} fileName="user-list" />
          <Button title="create new user" onClick={onCreate} startIcon={<AddIcon />}>
            Create
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
  data: PropTypes.any,
  onCreate: PropTypes.any
};

export default TableHeader;
