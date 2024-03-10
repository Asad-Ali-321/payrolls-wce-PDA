import Paper from '@mui/material/Paper';
import InputBase from '@mui/material/InputBase';
import IconButton from '@mui/material/IconButton';
import SearchIcon from '@mui/icons-material/Search';
import { Box } from '@mui/material';
import PropTypes from 'prop-types';
const TableSearch = (props) => {
  return (
    <Box sx={{ display: 'flex', justifyContent: 'flex-end', marginBottom: 1 }}>
      <Paper sx={{ p: '2px 4px', display: 'flex', alignItems: 'center', width: 400 }}>
        <InputBase
          sx={{ ml: 1, flex: 1 }}
          onChange={props.textChange}
          placeholder="Find Keyword"
          inputProps={{ 'aria-label': 'Find Keyword' }}
        />
        <IconButton type="button" sx={{ p: '10px' }} aria-label="search">
          <SearchIcon />
        </IconButton>
      </Paper>
    </Box>
  );
};

TableSearch.propTypes = {
  textChange: PropTypes.func
};
export default TableSearch;
