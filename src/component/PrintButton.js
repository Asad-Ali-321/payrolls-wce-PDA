import PropTypes from 'prop-types';
import PrintIcon from '@mui/icons-material/Print';
import { Button } from '@mui/material';
import ReactToPrint from 'react-to-print';

const PrintButton = (props) => {
  const { content } = props;

  return (
    <ReactToPrint
      bodyClass="print-agreement"
      content={content}
      trigger={() => (
        <Button size="large" type="primary" startIcon={<PrintIcon />}>
          Print
        </Button>
      )}
    />
  );
};

PrintButton.propTypes = {
  content: PropTypes.any
};

export default PrintButton;
