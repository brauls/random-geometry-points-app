import express from "express";
import axios from "axios";

const app = express();

if (process.env.NODE_ENV === "production") {
  app.use("/", express.static(__dirname + "/../client/build"));
} else {
  app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "http://localhost:3000");
    res.header("Access-Control-Allow-Headers", "Origin");
    next();
  });
}

app.get("/hello", (req, res) => {
  res.send("Hello world!");
});

app.get("/random-plane-points", (req, res) => {
  const url =
    "http://random-geometry-points-service.herokuapp.com/random-plane-points/3d/";
  console.log(req.query);
  const params = [
    {
      key: "num_points",
      value: 5
    },
    {
      key: "radius",
      value: 5
    },
    {
      key: "ref_x",
      value: 5
    },
    {
      key: "ref_y",
      value: 5
    },
    {
      key: "ref_z",
      value: 5
    },
    {
      key: "n_x",
      value: 5
    },
    {
      key: "n_y",
      value: 5
    },
    {
      key: "n_z",
      value: 5
    }
  ];
  const urlWithParams = createUrl(url, params);
  axios
    .get(urlWithParams)
    .then(response => {
      const randomPoints = response.data.map(pnt => ({
        x: pnt.x_coord,
        y: pnt.y_coord,
        z: pnt.z_coord
      }));
      res.send(randomPoints);
      console.log(randomPoints);
    })
    .catch(error => {
      if (error.response) {
        res.status(500).send("error");
        console.error("server error", response.status);
      } else if (error.request) {
        res.status(500).send("error");
        console.error("no server response");
      } else {
        res.status(500).send("error");
        console.error("error when setting up request");
      }
    });
  // res.send("getting plane points");
});

app.listen(5000, () => {
  console.log("App listening on port 5000");
});

const createUrl = (baseUrl, params) =>
  params.reduce((acc, param, index) => {
    const delim = index === 0 ? "?" : "&";
    return `${acc}${delim}${param.key}=${param.value}`;
  }, baseUrl);
