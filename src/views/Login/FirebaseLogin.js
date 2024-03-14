import React from 'react';

// material-ui
import { useTheme } from '@mui/material/styles';
import {
  Box,
  Button,
  Grid,
  TextField,
  Typography,
  FormControl,
  InputLabel,
  OutlinedInput,
  InputAdornment,
  IconButton
} from '@mui/material';
import 'react-toastify/dist/ReactToastify.css';
import { ToastContainer } from 'react-toastify';
// assets
import Visibility from '@mui/icons-material/Visibility';
import VisibilityOff from '@mui/icons-material/VisibilityOff';
import { requestPost } from 'api/requestServer';
import { useNavigate } from 'react-router';
import { toast } from 'react-toastify';

// ==============================|| FIREBASE LOGIN ||============================== //

const FirebaseLogin = () => {
  const theme = useTheme();
  const navigate = useNavigate();
  const [values, setValues] = React.useState({ email: '', password: '' });
  const [showPassword, setShowPassword] = React.useState(false);
  const [isSubmitting, setIsSubmitting] = React.useState(false);

  const handleClickShowPassword = () => {
    setShowPassword(!showPassword);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    setIsSubmitting(true);
    requestPost('auth/validate', values).then((res) => {
      if (res && res.code == 'ERR_NETWORK') toast.error('network error');
      else if (res && res.status != 'active') toast.error('account blocked');
      else if (res && res.status == 'active') {
        localStorage.setItem('user', JSON.stringify(res));
        navigate('/dashboard');
      } else toast.warning('invalid credentials');
      setIsSubmitting(false);
    });
  };

  const handleInputChange = async (event) => {
    const { name, value } = event.target;
    setValues({ ...values, [name]: value });
  };

  return (
    <form onSubmit={handleSubmit}>
      <ToastContainer />
      <TextField
        fullWidth
        label="Email Address / Username"
        margin="normal"
        name="email"
        onChange={handleInputChange}
        type="email"
        value={values.email}
        variant="outlined"
        required
      />

      <FormControl fullWidth sx={{ mt: theme.spacing(3), mb: theme.spacing(1) }}>
        <InputLabel htmlFor="outlined-adornment-password">Password</InputLabel>
        <OutlinedInput
          id="outlined-adornment-password"
          type={showPassword ? 'text' : 'password'}
          value={values.password}
          name="password"
          onChange={handleInputChange}
          label="Password"
          endAdornment={
            <InputAdornment position="end">
              <IconButton aria-label="toggle password visibility" onClick={handleClickShowPassword} edge="end" size="large">
                {showPassword ? <Visibility /> : <VisibilityOff />}
              </IconButton>
            </InputAdornment>
          }
        />
      </FormControl>
      <Grid container justifyContent="flex-end">
        <Grid item>
          <Typography variant="subtitle2" color="primary" sx={{ textDecoration: 'none' }}>
            Forgot Password?
          </Typography>
        </Grid>
      </Grid>

      <Box mt={2}>
        <Button color="primary" disabled={isSubmitting} fullWidth size="large" type="submit" variant="contained">
          Log In
        </Button>
      </Box>
    </form>
  );
};

export default FirebaseLogin;
