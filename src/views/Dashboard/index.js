import React, { useEffect, useState } from 'react';

// material-ui
import { useTheme, styled } from '@mui/material/styles';
import { Grid, Card, CardHeader, CardContent, Typography, Divider } from '@mui/material';

//project import
import SalesLineCard from './SalesLineCard';
import SalesLineCardData from './chart/sale-chart-1';

import RevenuChartCard from './RevenuChartCard';
import RevenuChartCardData from './chart/revenu-chart';
import ReportCard from './ReportCard';
import { gridSpacing } from 'config.js';

// assets
import TrendingUpIcon from '@mui/icons-material/TrendingUp';
import TrendingDownIcon from '@mui/icons-material/TrendingDown';
import MonetizationOnTwoTone from '@mui/icons-material/MonetizationOnTwoTone';
import DescriptionTwoTone from '@mui/icons-material/DescriptionTwoTone';
import ThumbUpAltTwoTone from '@mui/icons-material/ThumbUpAltTwoTone';
import CalendarTodayTwoTone from '@mui/icons-material/CalendarTodayTwoTone';
import { requestGet } from 'api/requestServer';

// custom style
const FlatCardBlock = styled((props) => <Grid item sm={6} xs={12} {...props} />)(({ theme }) => ({
  padding: '25px 25px',
  borderLeft: '1px solid' + theme.palette.background.default,
  [theme.breakpoints.down('sm')]: {
    borderLeft: 'none',
    borderBottom: '1px solid' + theme.palette.background.default
  },
  [theme.breakpoints.down('md')]: {
    borderBottom: '1px solid' + theme.palette.background.default
  }
}));

// ==============================|| DASHBOARD DEFAULT ||============================== //

const Default = () => {
  const theme = useTheme();
  const [directorWiseStaff, setDirectorWiseStaff] = useState([]);
  const [designationWiseStaff, setDesignationWiseStaff] = useState([]);
  const [monthlyPayWiseStaff, setMonthlyPayWiseStaff] = useState([]);

  const getDirectorWiseStaff = async () => {
    requestGet('Officials/directorWiseStaff').then((res) => {
      if (res) setDirectorWiseStaff(res);
      else setDirectorWiseStaff([]);
    });
  };

  const getDesignationWiseStaff = async () => {
    requestGet('Officials/designationWiseStaff').then((res) => {
      if (res) setDesignationWiseStaff(res);
      else setDesignationWiseStaff([]);
    });
  };

  const getMonthlyPayWiseStaff = async () => {
    requestGet('Officials/monthlyPayWiseStaff').then((res) => {
      if (res) setMonthlyPayWiseStaff(res);
      else setMonthlyPayWiseStaff([]);
    });
  };

  useEffect(() => {
    getDirectorWiseStaff();
    getDesignationWiseStaff();
    getMonthlyPayWiseStaff();
  }, []);

  return (
    <Grid container spacing={gridSpacing}>
      <Grid item xs={12}>
        <Grid container spacing={gridSpacing}>
          <Grid item lg={3} sm={6} xs={12}>
            <ReportCard
              primary="$30200"
              secondary="All Earnings"
              color={theme.palette.warning.main}
              footerData="10% changes on profit"
              iconPrimary={MonetizationOnTwoTone}
              iconFooter={TrendingUpIcon}
            />
          </Grid>
          <Grid item lg={3} sm={6} xs={12}>
            <ReportCard
              primary="145"
              secondary="Task"
              color={theme.palette.error.main}
              footerData="28% task performance"
              iconPrimary={CalendarTodayTwoTone}
              iconFooter={TrendingDownIcon}
            />
          </Grid>
          <Grid item lg={3} sm={6} xs={12}>
            <ReportCard
              primary="290+"
              secondary="Page Views"
              color={theme.palette.success.main}
              footerData="10k daily views"
              iconPrimary={DescriptionTwoTone}
              iconFooter={TrendingUpIcon}
            />
          </Grid>
          <Grid item lg={3} sm={6} xs={12}>
            <ReportCard
              primary="500"
              secondary="Downloads"
              color={theme.palette.primary.main}
              footerData="1k download in App store"
              iconPrimary={ThumbUpAltTwoTone}
              iconFooter={TrendingUpIcon}
            />
          </Grid>
        </Grid>
      </Grid>
      <Grid item xs={12}>
        <Grid container spacing={gridSpacing}>
          <Grid item lg={4} xs={12}>
            <Card>
              <CardHeader
                title={
                  <Typography component="div" className="card-header">
                    Directorate Wise Officials
                  </Typography>
                }
              />
              <Divider />
              <CardContent>
                <Grid container spacing={gridSpacing}>
                  {directorWiseStaff.map((row) => (
                    <Grid item xs={12} style={{ paddingTop: '2px' }} key={row.directorate}>
                      <Grid container alignItems="center">
                        <Grid item sm zeroMinWidth>
                          <Typography variant="body2">{row.directorate}</Typography>
                        </Grid>
                        <Grid item>
                          <Typography variant="body2" align="right">
                            {row.count}
                          </Typography>
                        </Grid>
                      </Grid>
                      <hr style={{ margin: 0 }} />
                    </Grid>
                  ))}
                </Grid>
              </CardContent>
            </Card>
          </Grid>
          <Grid item lg={4} xs={12}>
            <Card>
              <CardHeader
                title={
                  <Typography component="div" className="card-header">
                    Designation Wise Officials
                  </Typography>
                }
              />
              <Divider />
              <CardContent>
                <Grid container spacing={gridSpacing}>
                  {designationWiseStaff.map((row) => (
                    <Grid item xs={12} style={{ paddingTop: '2px' }} key={row.designation}>
                      <Grid container alignItems="center">
                        <Grid item sm zeroMinWidth>
                          <Typography variant="body2">{row.designation}</Typography>
                        </Grid>
                        <Grid item>
                          <Typography variant="body2" align="right">
                            {row.count}
                          </Typography>
                        </Grid>
                      </Grid>
                      <hr style={{ margin: 0 }} />
                    </Grid>
                  ))}
                </Grid>
              </CardContent>
            </Card>
          </Grid>
          <Grid item lg={4} xs={12}>
            <Card>
              <CardHeader
                title={
                  <Typography component="div" className="card-header">
                    Pay Wise Officials
                  </Typography>
                }
              />
              <Divider />
              <CardContent>
                <Grid container spacing={gridSpacing}>
                  {monthlyPayWiseStaff.map((row) => (
                    <Grid item xs={12} style={{ paddingTop: '2px' }} key={row.monthly_pay}>
                      <Grid container alignItems="center">
                        <Grid item sm zeroMinWidth>
                          <Typography variant="body2">{row.monthly_pay}</Typography>
                        </Grid>
                        <Grid item>
                          <Typography variant="body2" align="right">
                            {row.count}
                          </Typography>
                        </Grid>
                      </Grid>
                      <hr style={{ margin: 0 }} />
                    </Grid>
                  ))}
                </Grid>
              </CardContent>
            </Card>
          </Grid>
          <Grid item lg={8} xs={12}>
            <Grid container spacing={gridSpacing}>
              <Grid item xs={12} sm={6}>
                <Grid container spacing={gridSpacing}>
                  <Grid item xs={12}>
                    <SalesLineCard
                      chartData={SalesLineCardData}
                      title="Sales Per Day"
                      percentage="3%"
                      icon={<TrendingDownIcon />}
                      footerData={[
                        {
                          value: '$4230',
                          label: 'Total Revenue'
                        },
                        {
                          value: '321',
                          label: 'Today Sales'
                        }
                      ]}
                    />
                  </Grid>
                  <Grid item xs={12} sx={{ display: { md: 'block', sm: 'none' } }}>
                    <Card>
                      <CardContent sx={{ p: '0 !important' }}>
                        <Grid container alignItems="center" spacing={0}>
                          <FlatCardBlock>
                            <Grid container alignItems="center" spacing={1}>
                              <Grid item>
                                <Typography variant="subtitle2" align="left">
                                  REALTY
                                </Typography>
                              </Grid>
                              <Grid item sm zeroMinWidth>
                                <Typography variant="h5" sx={{ color: theme.palette.error.main }} align="right">
                                  -0.99
                                </Typography>
                              </Grid>
                            </Grid>
                          </FlatCardBlock>
                          <FlatCardBlock>
                            <Grid container alignItems="center" spacing={1}>
                              <Grid item>
                                <Typography variant="subtitle2" align="left">
                                  INFRA
                                </Typography>
                              </Grid>
                              <Grid item sm zeroMinWidth>
                                <Typography variant="h5" sx={{ color: theme.palette.success.main }} align="right">
                                  -7.66
                                </Typography>
                              </Grid>
                            </Grid>
                          </FlatCardBlock>
                        </Grid>
                      </CardContent>
                    </Card>
                  </Grid>
                </Grid>
              </Grid>
              <Grid item xs={12} sm={6}>
                <RevenuChartCard chartData={RevenuChartCardData} />
              </Grid>
            </Grid>
          </Grid>
        </Grid>
      </Grid>
    </Grid>
  );
};

export default Default;
