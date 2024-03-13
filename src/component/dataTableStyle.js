export const DataTableStyle = {
  muiPaginationProps: {
    rowsPerPageOptions: [50, 100, 200]
  },
  initialState: { pagination: { pageSize: 50 }, density: 'compact', showGlobalFilter: true },
  muiTablePaperProps: {
    sx: {
      backgroundColor: 'white'
    }
  },
  muiTableContainerProps: {
    sx: {
      maxHeight: '70vh'
    }
  },
  muiTableProps: {
    sx: {
      padding: '0.5rem 1.5rem'
    }
  },
  muiTableBodyCellProps: {
    sx: {
      fontWeight: 'normal',
      fontSize: '0.7rem',
      padding: 0.5
    }
  },
  muiTableHeadCellProps: {
    sx: {
      fontWeight: 'Bold',
      fontSize: '0.7rem',
      padding: 0
    }
  },
  muiTableBodyProps: {
    sx: {
      '& tr > td': {
        backgroundColor: 'white'
      }
    }
  },
  muiTableHeadProps: {
    sx: {
      '& tr > th': {
        backgroundColor: 'white'
      }
    }
  }
};

export const PrintDataTableStyle = {
  muiPaginationProps: {
    rowsPerPageOptions: [-1]
  },
  initialState: { pagination: { pageSize: -1 }, density: 'compact', showGlobalFilter: true },
  muiTablePaperProps: {
    sx: {
      backgroundColor: 'white'
    }
  },
  muiTableProps: {
    sx: {
      margin: '0.5rem 1.5rem'
    }
  },
  muiTableBodyCellProps: {
    sx: {
      fontWeight: 'normal',
      fontSize: '0.7rem',
      padding: 0.5
    }
  },
  muiTableHeadCellProps: {
    sx: {
      fontWeight: 'Bold',
      fontSize: '0.7rem',
      padding: 0
    }
  },
  muiTableBodyProps: {
    sx: {
      '& tr > td': {
        backgroundColor: 'white'
      }
    }
  },
  muiTableHeadProps: {
    sx: {
      '& tr > th': {
        backgroundColor: 'white'
      }
    }
  }
};
