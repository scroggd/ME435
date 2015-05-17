package edu.rosehulman.me435;

import android.app.Activity;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.Location;

public class FieldOrientation implements SensorEventListener {
  public static final String TAG = FieldOrientation.class.getSimpleName();

  /** Listener that will be called when new sensor readings are available. */
  private FieldOrientationListener mListener;

  /** Reference to the SensorManager. */
  private SensorManager mSensorManager = null;

  /** Azimuth, pitch, and roll values of the device. */
  private float[] mOrientationValues = new float[3];

  /** Temporary matrix used in the orientation calculation. */
  private final float[] mRotationMatrix = new float[16];

  /** Field angle. The offset of the field X axis to due North. */
  private float mFieldBearing;

  /**
   * Instantiate the FieldOrientationListener with a listener only. The field
   * offset angle will be set to due North (0 offset).
   * 
   * @param listener
   *          Listener that implements FieldOrientationListener that will be
   *          called with updates.
   */
  public FieldOrientation(FieldOrientationListener listener) {
    this(listener, 0);
  }

  /**
   * Give the Field Orientation a listener and coordinates for the field.  This
   * approach is slightly better than no orientation information, but it assumes
   * the compass works perfectly (hopefully you know enough about the magnetic
   * field sensor to laugh at jokes like that).
   * 
   * @param listener
   *          Listener that implements FieldOrientationListener that will be
   *          called with updates.
   * @param latitudeOrigin
   *          Latitude of the field origin.
   * @param longitudeOrigin
   *          Longitude of the field origin.
   * @param latitudeOnXAxis
   *          Latitude of any point that is on the X axis.
   * @param longitudeOnXAxis
   *          Longitude of any point that is on the X axis.
   */
  public FieldOrientation(FieldOrientationListener listener, double latitudeOrigin,
      double longitudeOrigin, double latitudeOnXAxis, double longitudeOnXAxis) {
    this(listener, 0); // Java requires calls to other constructors absolutely first (lame).
    float[] originToXAxisLocation = new float[2];
    Location.distanceBetween(latitudeOrigin, longitudeOrigin, latitudeOnXAxis, longitudeOnXAxis,
        originToXAxisLocation);
    setFieldBearing(originToXAxisLocation[1]); // Now we are ready to set the field bearing.
  }

  /**
   * Set the field offset angle. This is the bearing of the field, degrees East
   * of North.
   * 
   * @param fieldBearing
   *          Bearing of the field, degrees East of North.
   */
  public void setFieldBearing(float fieldBearing) {
    mFieldBearing = fieldBearing;
  }

  /**
   * Construct the FieldOrientation object with a listener and known bearing.
   *
   * @param listener
   *          Listener that implements FieldOrientationListener that will be
   *          called with updates.
   * @param fieldBearing 
   */
  public FieldOrientation(FieldOrientationListener listener, float fieldBearing) {
    mListener = listener;
    mFieldBearing = fieldBearing;
  }

  /** Begin receiving sensor updates. */
  public void registerListener(Context context) {
    mSensorManager = (SensorManager) context.getSystemService(Activity.SENSOR_SERVICE);
    Sensor rotationVectorSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR);
    mSensorManager.registerListener(this, rotationVectorSensor, SensorManager.SENSOR_DELAY_NORMAL);
  }

  /** Stop receiving sensor updates. */
  public void unregisterListener() {
    if (mSensorManager != null) {
      mSensorManager.unregisterListener(this);
    }
  }

  /**
   * This function sets the current heading to a known value. This will update
   * the field bearing as necessary to make the current value correct.
   * 
   * @param currentFieldHeading
   *          The current known field heading. Note that the positive X axis is
   *          at 0 degrees.
   */
  public void setCurrentFieldHeading(double currentFieldHeading) {
    mFieldBearing = getRevisedAzimuth() + (float) currentFieldHeading;
  }

  @Override
  public void onSensorChanged(SensorEvent event) {
    if (event.sensor.getType() == Sensor.TYPE_ROTATION_VECTOR) {
      SensorManager.getRotationMatrixFromVector(mRotationMatrix, event.values);

      // From: https://github.com/gast-lib/gast-lib/blob/master/app/src/root/gast/playground/sensor/NorthFinder.java
      SensorManager.remapCoordinateSystem(mRotationMatrix,
              SensorManager.AXIS_X, SensorManager.AXIS_Z,
              mRotationMatrix);

      SensorManager.getOrientation(mRotationMatrix, mOrientationValues);
      mOrientationValues[0] = (float) Math.toDegrees(mOrientationValues[0]);
      mOrientationValues[1] = (float) Math.toDegrees(mOrientationValues[1]);
      mOrientationValues[2] = (float) Math.toDegrees(mOrientationValues[2]);
      dispatchOnSensorChangedEvent();
    }
  }

  /**
   * Sends the onSensorChanged event to the FieldOrientationListener.
   */
  private void dispatchOnSensorChangedEvent() {
    float fieldHeading = mFieldBearing - getRevisedAzimuth();
    fieldHeading = normalizeAngle(fieldHeading);
    mListener.onSensorChanged(fieldHeading, mOrientationValues);
  }

  /**
   * Normalize any angle to -180 to 180.
   * 
   * @param angle
   *          Original angle that is not normalized.
   * @return A normalized equivalent angle.
   */
  private float normalizeAngle(float angle) {
    while (angle <= -180.0)
      angle += 360.0;
    while (angle > 180.0)
      angle -= 360.0;
    return angle;
  }


  /**
   * Calculates the Azimuth based on the orientation values.
   * @return Azimuth (assuming the device is in portrait)
   */
  private float getRevisedAzimuth() {
    // I have absolutely no idea why, how, or when the rotation vector sensor changed the way it works.
    // BUT this seems to be a solution to the problem to accurately find azimuth now.
    float revisedAzimuth = Math.abs(mOrientationValues[0]) + Math.abs(mOrientationValues[2]);
    if (mOrientationValues[2] > 0) {
      revisedAzimuth *= -1;
    }
    return revisedAzimuth;
  }

  // Other required methods from the LocationListener.
  @Override
  public void onAccuracyChanged(Sensor sensor, int accuracy) {
    // Intentionally left blank.
  }
  
  /** Return the field bearing used in the calculation. */
  public float getFieldBearing() {
    return mFieldBearing;
  }
}
