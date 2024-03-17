import { Box, Button, Divider, Typography } from '@mui/material';
import PropTypes from 'prop-types';
import { MRT_GlobalFilterTextField, MRT_ShowHideColumnsButton } from 'material-react-table';
import ExportCSVButton from 'component/ExportCSV';
import AddIcon from '@mui/icons-material/Add';

const TableHeader = (props) => {
  const { table, data, onCreate } = props;

  return (
    <>
      <Box display="flex" style={{ margin: '0.5rem 1.5rem' }} justifyContent="space-between" alignItems="center">
        <div display="flex">
          <Typography variant="h5">Directorates List</Typography>
        </div>
        <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
          <ExportCSVButton data={data} fileName="directorates" />
          <Divider orientation="vertical" style={{ margin: '0px 8px' }} flexItem />
          <Button title="create new employee" onClick={onCreate} startIcon={<AddIcon />}>
            Create
          </Button>
          <Divider orientation="vertical" style={{ margin: '0px 8px' }} flexItem />
          <MRT_GlobalFilterTextField table={table} />
          <Divider orientation="vertical" style={{ margin: '0px 8px' }} flexItem />
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
