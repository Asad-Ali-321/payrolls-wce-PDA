import Paper from '@mui/material/Paper';
import InputBase from '@mui/material/InputBase';
import IconButton from '@mui/material/IconButton';
import SearchIcon from '@mui/icons-material/Search';
import { Autocomplete, CircularProgress, Grid, TextField } from '@mui/material';
import PropTypes from 'prop-types';
import { useEffect, useState } from 'react';
import { getDirectorates } from 'api/official';
const TableSearch = (props) => {
  const [loading, setLoading] = useState(false);
  const [directorates, setDirectorates] = useState([]);

  useEffect(() => {
    setLoading(true);
    getDirectorates().then((res) => {
      if (res.status) {
        
        setDirectorates(res.data);
        setLoading(false);
      }
    });
  }, []);
  return (
    <Grid container spacing={2} mb={2} justifyContent="flex-end">
      <Grid item lg={3} xs={12}>
        {!loading ? (
          <Autocomplete
            disablePortal
            multiple
            options={directorates}
            onChange={(event, newInputValue) => {
              if (newInputValue) props.directorateChange(newInputValue.map((item) => item.directorate));
            }}
            getOptionLabel={(option) => option.directorate}
            getOptionKey={(option) => option.directorate}
            renderInput={(params) => (
              <TextField {...params} required name="Directorate" size="small" variant="standard" label="Filter Directorates" />
            )}
            renderOption={(props, option) => (
              <li {...props} key={option.directorate}>
                {option.directorate}
              </li>
            )}
          />
        ) : (
          <CircularProgress />
        )}
      </Grid>
      <Grid item lg={3} xs={12}>
        <Paper sx={{ display: 'flex', alignItems: 'center', width: '100%' }}>
          <InputBase
            sx={{ ml: 1, flex: 1 }}
            onChange={(event) => {
              props.textChange(event.target.value);
            }}
            placeholder="Find Keyword"
            inputProps={{ 'aria-label': 'Find Keyword' }}
          />
          <IconButton type="button" sx={{ p: '10px' }} aria-label="search">
            <SearchIcon />
          </IconButton>
        </Paper>
      </Grid>
    </Grid>
  );
};

TableSearch.propTypes = {
  textChange: PropTypes.func,
  directorateChange: PropTypes.func
};
export default TableSearch;
