import PropTypes from 'prop-types';
import DownloadIcon from '@mui/icons-material/Download';
import { CSVLink } from 'react-csv';
import { Button } from '@mui/material';
import { useRef } from 'react';

const ExportCSVButton = (props) => {
  const { data, fileName } = props;
  const downloadButtonRef = useRef(null);

  return (
    <Button
      title="export table"
      startIcon={<DownloadIcon />}
      onClick={() => {
        downloadButtonRef.current.link.click();
      }}
    >
      Export
      <CSVLink
        data={data}
        style={{ textDecoration: 'none', cursor: 'pointer', display: 'none' }}
        filename={fileName ? `${fileName}-WCE.csv` : 'file-WCE.csv'}
        title="export payroll"
        ref={downloadButtonRef}
        target="_blank"
      ></CSVLink>
    </Button>
  );
};

ExportCSVButton.propTypes = {
  data: PropTypes.any,
  fileName: PropTypes.string
};

export default ExportCSVButton;
